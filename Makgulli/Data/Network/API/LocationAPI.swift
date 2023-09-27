//
//  LocationAPI.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import Alamofire

enum LocationAPI {
    case fetchSearchLocations(String, String, String, Int, Int)
}

extension LocationAPI: TargetType {
    var baseURL: String {
        switch self {
        case .fetchSearchLocations:
            return URLConstants.kakao
        }
    }
    
    var path: String {
        switch self {
        case .fetchSearchLocations:
            return "/local/search/keyword.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchSearchLocations:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchSearchLocations(query, x, y, page, display):
            let requestDTO = SearchLocationRequestDTO(query: query, x: x, y: y, page: page, display: display).toDictionary
            return .requestParameters(
                parameters: requestDTO,
                encoding: URLEncoding.queryString)
        }
    }
}
