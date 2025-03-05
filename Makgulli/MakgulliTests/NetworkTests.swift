//
//  NetworkTests.swift
//  MakgulliTests
//
//  Created by kyuchul on 12/14/24.
//

import Foundation
import Testing

@testable import Makgulli

import Alamofire

struct NetworkTests {
    @Test func 헤더_설정_체크() {
        let header = HeaderType.default.toHTTPHeaders
        
        let url: URL = .init(string: "https://www.google.com")!
        var urlRequest: URLRequest = .init(url: url)
        
        var expected = HTTPHeaders.default
        expected.add(name: "Accept", value: "application/json")
        
        urlRequest.headers = header
        
        #expect(urlRequest.headers.dictionary == expected.dictionary)
        #expect(urlRequest.headers.value(for: "accept") == "application/json")
    }
    
    @Test func 단일_파라미터_설정() throws {
        var urlRequest: URLRequest = .init(
          url: .init(string: "https://www.naver.com")!
        )
        let encode = URLEncoding.default
        
        let parameter: Parameters = ["key": "value"]
        
        let result = try encode.encode(urlRequest, with: parameter)
        
        #expect(result.url?.query() == "key=value")
    }
    


//    @Test func 헤더_설정() {
//        var header = HTTPHeader(name: "key", value: "value")
//
//        let url: URL = .init(string: "https://www.google.com")!
//        var urlRequest: URLRequest = .init(url: url)
//
//        let expected: [String: String] = ["key": "value"]
//
//        urlRequest.setHeaders([header])
//
//        #expect(urlRequest.allHTTPHeaderFields == expected)
//        #expect(urlRequest.value(forHTTPHeaderField: "key") == "value")
//    }
//
//    @Test func 헤더_여러개_설정() {
//        var header = [
//            HTTPHeader(name: "key", value: "value"),
//            HTTPHeader(name: "kim", value: "kyuchul")
//        ]
//
//        let url: URL = .init(string: "https://www.google.com")!
//        var urlRequest: URLRequest = .init(url: url)
//
//        let expected: [String: String] = [
//            "key": "value",
//            "kim": "kyuchul"
//        ]
//
//        urlRequest.setHeaders(header)
//
//        #expect(urlRequest.allHTTPHeaderFields == expected)
//    }

}
