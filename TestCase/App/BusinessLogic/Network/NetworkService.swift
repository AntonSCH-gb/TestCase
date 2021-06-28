//
//  NetworkService.swift
//  TestCase
//
//  Created by Anton Scherbaev on 24.06.2021.
//

import Foundation
import Alamofire

enum UploadResult {
    case success, needNewToken, error
}

protocol NetworkServiceProtocol {
    
    func getSessionToken(withLogin login: String, andBase64EncodedPassword password: String, _ complitionWithToken: @escaping (String?) -> Void)
    func uploadWithUpdateTokenIfNeeded(files: [UploadFileModel], complition: @escaping (UploadResult) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getSessionToken(withLogin login: String, andBase64EncodedPassword password: String, _ complitionWithToken: @escaping (String?) -> Void) {
        
        let target = NetworkEndPoints.login(login: login, password: password)
        var token: String?
        
        AF.request(target.urlPath, method: target.method, parameters: target.parameters, encoding: target.encoding, headers: target.headers).responseJSON(completionHandler: { responce in
            token = responce.value as? String
//            print(token)
            complitionWithToken(token)
        })
        
    }
    
    func uploadWithUpdateTokenIfNeeded(files: [UploadFileModel], complition: @escaping (UploadResult) -> Void){
        uploadFiles(files: files, complition: { result in
            switch result {
            case .error:
                complition(UploadResult.error)
            case .success:
                complition(UploadResult.success)
            case .needNewToken:
                CurrentSession.shared.updateToken{ isUpdated in
                    if isUpdated {
                        self.uploadFiles(files: files, complition: { result in
                            if result == .success {
                                complition(.success)
                            } else {
                                complition(.error)
                            }
                        })
                    } else {
                        complition(UploadResult.error)
                    }
                }
            }
        })
    }
    
    private func uploadFiles(files: [UploadFileModel], complition: @escaping (UploadResult) -> Void){
        let target = NetworkEndPoints.sendData(token: CurrentSession.shared.token)
        guard let requestURL = try? URLRequest(url: target.urlPath, method: target.method, headers: target.headers) else { return }
        let request = AF.upload(multipartFormData: { multipartFormData in
            for item in files {
                    multipartFormData.append(item.fileData, withName: "file", fileName: item.fileName, mimeType: nil)
            }
        }, with: requestURL)
        
        request.response(completionHandler: { response in
            guard let value = response.value,
                  let data = value,
                  let stringResponse = String.init(data: data, encoding: .utf8) else {
                complition(UploadResult.error)
                return
            }
            if stringResponse.contains("true") {
                complition(UploadResult.success)
            } else if stringResponse.contains("Authentication failed") {
                complition(UploadResult.needNewToken)
            } else if let error = response.error {
                print(error.localizedDescription)
                complition(UploadResult.error)
            }
        })
    }
    
    
    
    
}
