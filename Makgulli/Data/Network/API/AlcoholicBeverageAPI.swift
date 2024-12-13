//
//  AlcoholicBeverageAPI.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

import Alamofire

enum AlcoholicBeverageAPI {
    case fetchTraditionalAlcoholicBeverage(page: Int, perPage: Int = 20)
}

extension AlcoholicBeverageAPI: TargetType {
    var baseURL: String {
        switch self {
        case .fetchTraditionalAlcoholicBeverage:
            return URLConstants.dataGo
        }
    }
    
    var path: String {
        switch self {
        case .fetchTraditionalAlcoholicBeverage:
            return "/15048755/v1/uddi:1037e3c8-3964-47e4-afba-b4f0dd3eeef6"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTraditionalAlcoholicBeverage:
            return .get
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .fetchTraditionalAlcoholicBeverage:
            return .default
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchTraditionalAlcoholicBeverage(page, perPage):
            return .requestParameters(parameters: [
                "page": page,
                "perPage": perPage,
                "serviceKey": Bundle.main.openDataPortalServiceKey
            ], encoding: URLEncoding.queryString)
        }
    }
}

