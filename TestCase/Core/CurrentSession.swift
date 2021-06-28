//
//  CurrentSession.swift
//  TestCase
//
//  Created by Anton Scherbaev on 25.06.2021.
//

import Foundation

class CurrentSession {
    
    enum SessionError: Error {
        case passwordEncodeError
        case loginDenided
    }
    
    static let shared = CurrentSession()
    
    private let accessDenidedToken = "NoAccess"
    
    private(set) var login: String = ""
    private(set) var passwordEncoded: String = ""
    private(set) var token: String = ""
    
    private var getTokenService: NetworkService = NetworkService()
    
    
    private init() {}
    
    func login(with login: String, and password: String, complition: @escaping (Bool) -> Void) {
        if let encodedPassword = Base64StringEncoder.encode(string: password) {
            getTokenService.getSessionToken(withLogin: login, andBase64EncodedPassword: encodedPassword) { requestToken in
                self.token = requestToken ?? self.accessDenidedToken
                complition(self.token != self.accessDenidedToken)
            }
        } else {
            complition(false)
        }
    }
    
    func updateToken(complition: @escaping (Bool) -> Void) {
            getTokenService.getSessionToken(withLogin: login, andBase64EncodedPassword: passwordEncoded) { requestToken in
                self.token = requestToken ?? self.accessDenidedToken
                complition(self.token != self.accessDenidedToken)
            }
    }
    
}
