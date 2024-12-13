//
//  AlcoholicBeverageVO.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

struct AlcoholicBeverage {
    let page: Int
    let currentCount: Int
    let totalCount: Int
    let liquor: [TraditionalLiquor]
}

struct TraditionalLiquor {
    let name: String
    let alcoholContent: String
    let specification: String
    let mainIngredient: String
    let manufacturer: String
}
