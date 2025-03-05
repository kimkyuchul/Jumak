//
//  URLRequestable.swift
//  Makgulli
//
//  Created by kyuchul on 11/29/24.
//

import Foundation

typealias Parameters = [String: Any]

protocol URLRequestable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethodType { get }
    var header: [HTTPHeader]? { get }
    var parameters: Parameters? { get }
    var encode: ParameterEncodable { get }
    func asURLRequest() throws -> URLRequest
}

extension URLRequestable {
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path),
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 3.0)
        urlRequest.httpMethod = method.rawValue
        if let header { urlRequest.setHeaders(header) }
        return try encode.encode(urlRequest, with: parameters)
    }
}
