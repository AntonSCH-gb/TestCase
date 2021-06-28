//
//  Base64StringEncoder.swift
//  TestCase
//
//  Created by Anton Scherbaev on 24.06.2021.
//

import Foundation

class Base64StringEncoder {
    class func encode(string: String) -> String? {
        let utf8str = string.data(using: .utf8)

        guard let base64Encoded = utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) else { return nil }
        return base64Encoded
    }
}
