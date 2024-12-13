//
//  HeaderType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import Alamofire

enum HeaderType {
    case `default`
    case withKakaoApiKey
}

extension HeaderType {
    var toHTTPHeaders: HTTPHeaders {
        var headers = HTTPHeaders.default
        headers.add(name: "accept", value: "application/json")
        
        switch self {
        case .default:
            return headers
            
        case .withKakaoApiKey:
            headers.add(name: "Authorization", value: "KakaoAK \(Bundle.main.kakaoAPIKey)")
            return headers
        }
    }
}
