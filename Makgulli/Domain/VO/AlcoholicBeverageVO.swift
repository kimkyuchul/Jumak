//
//  AlcoholicBeverageVO.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

struct AlcoholicBeverage: Equatable {
    let page: Int
    let currentCount: Int
    let totalCount: Int
    let liquor: [TraditionalLiquor]
}

struct TraditionalLiquor: Equatable {
    let name: String
    let alcoholContent: String
    let specification: String
    let mainIngredient: String
    let manufacturer: String
    let liquorType: LiquorType
}

enum LiquorType: String, Equatable, CaseIterable {
    case 와인
    case 소주
    case 막걸리
    case 전통주
}

extension LiquorType {
    static func filterLiquorType(name: String, manufacturer: String) -> LiquorType {
        return LiquorType.allCases.first { name.contains($0.rawValue) || manufacturer.contains($0.rawValue) } ?? .전통주
    }
}

