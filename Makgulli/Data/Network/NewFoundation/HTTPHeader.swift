//
//  HTTPHeader.swift
//  Makgulli
//
//  Created by kyuchul on 11/29/24.
//

import Foundation

struct HTTPHeader: Hashable {
    let name: String
    let value: String
}

extension HTTPHeader: CustomStringConvertible {
    public var description: String {
        "\(name): \(value)"
    }
}

extension HTTPHeader {
    static var `default`: HTTPHeader {
        HTTPHeader(name: "accept", value: "application/json")
    }
    
    static var kakao: HTTPHeader {
        HTTPHeader(name: "Authorization", value: "KakaoAK \(Bundle.main.kakaoAPIKey)")
    }
}

extension [HTTPHeader] {
    var toDictionary: [String: String] {
        let keysAndValue = self.map { ($0.name, $0.value) }
        return Dictionary(keysAndValue) { _, last in
            return last
        }
    }
}

extension URLRequest {
    mutating func setHeaders(_ header: [HTTPHeader]) {
        header.forEach { self.setValue($0.value, forHTTPHeaderField: $0.name) }
    }
}
