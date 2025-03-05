//
//  ParameterEncodable.swift
//  Makgulli
//
//  Created by kyuchul on 11/29/24.
//

import Foundation

enum ParameterEncodeError: Error {
    case jsonEncodingFailed
    case invalidJSONObject
    case urlFailed
}

protocol ParameterEncodable {
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
}

struct URLParameterEncoder: ParameterEncodable {
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters else { return urlRequest }
        
        var urlRequest = urlRequest
        
        guard let url = urlRequest.url else {
            throw ParameterEncodeError.urlFailed
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return urlRequest
        }
        
        let percentEncodedQuery = parameters.map { URLQueryItem(name: $0.urlEncoded, value: "\($1)".urlEncoded) }
        
        urlComponents.percentEncodedQueryItems = percentEncodedQuery
        
        urlRequest.url = urlComponents.url
        
        return urlRequest
    }
}

struct JSONEncodar: ParameterEncodable {
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters else { return urlRequest }
        
        var urlRequest = urlRequest
        
        guard  JSONSerialization.isValidJSONObject(parameters) else {
            throw ParameterEncodeError.invalidJSONObject
        }
        
        do {
            let encodedParameters = try JSONSerialization.data(withJSONObject: parameters)
            
            urlRequest.httpBody = encodedParameters
        } catch {
            throw ParameterEncodeError.jsonEncodingFailed
        }
        
        return urlRequest
    }
}

extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
}
