//
//  TargetType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var headers: HeaderType { get }
    var path: String { get }
    var task: Task { get }
}

extension TargetType {
    var headers: HeaderType {
        return .withKakaoApiKey
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.headers = headers.toHTTPHeaders
        
        urlRequest = try addParameter(request: urlRequest)
        return urlRequest
    }
    
    private func addParameter(request: URLRequest) throws -> URLRequest {
        var request = request
        
        switch task {
        case .requestPlain:
            break
    
        case .requestJSONEncodable(let parameters):
            request.httpBody = try JSONEncoder().encode(parameters)
        case .requestCustomJSONEncodable(let parameters, encoder: let encoder):
            request.httpBody = try encoder.encode(parameters)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            request = try encoding.encode(request, with: parameters)
        }
        
        return request
    }
}
