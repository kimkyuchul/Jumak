//
//  CocktailAPI.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import Foundation

import Alamofire

enum CocktailAPI {
    case searchByFirstLetter(String)
}

extension CocktailAPI: TargetType {
    var baseURL: String { URLConstants.cocktailDB }
    var path: String { "/search.php" }
    var method: HTTPMethod { .get }
    var headers: HeaderType { .default }

    var task: Task {
        switch self {
        case .searchByFirstLetter(let letter):
            return .requestParameters(
                parameters: ["f": letter],
                encoding: URLEncoding.queryString
            )
        }
    }
}
