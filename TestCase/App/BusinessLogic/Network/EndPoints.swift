//
//  EndPoints.swift
//  TestCase
//
//  Created by Anton Scherbaev on 24.06.2021.
//

import Foundation
import Foundation
import Alamofire

enum NetworkEndPoints {
    case login(login: String, password: String)
    case sendData(token: String)
//    case refreshToken(refreshToken: String, fingerprint: String)
//    case restorePassword(email: String)
}

extension NetworkEndPoints: Target {
    var baseURL: URL {
        return URL(string: "http://test.dewival.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/login/"
        case .sendData:
            return "/api/sendfile/"
        }
    }
    
    var keyPath: String? {
        return nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .sendData:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .login:
            return nil
        case let .sendData(token):
            return [HTTPHeader.authorization(bearerToken: token)]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let .login(login, password):
            return [
                "login": login,
                "password": password,
            ]
        case .sendData:
            return nil
        }
        
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
}
