//
//  Target.swift
//  TestCase
//
//  Created by Anton Scherbaev on 24.06.2021.
//

import Foundation
import Alamofire

protocol Target {
    var baseURL: URL { get }
    var path: String { get }
    var keyPath: String? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncoding { get }
}

extension Target {
    var urlPath: URL {
        return URL(string: baseURL.absoluteString + path)!
    }
}
