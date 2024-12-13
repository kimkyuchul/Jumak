//
//  AlcoholicBeverageDTO.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

struct AlcoholicBeverageDTO: Decodable {
    let page: Int
    let perPage: Int
    let totalCount: Int
    let currentCount: Int
    let matchCount: Int
    let data: [TraditionalLiquorDTO]
}

extension AlcoholicBeverageDTO {
    func toDomain() -> AlcoholicBeverage {
        .init(
            page: page,
            currentCount: currentCount,
            totalCount: totalCount,
            liquor: data.map { $0.toDomain() }
        )
    }
}

struct TraditionalLiquorDTO: Decodable {
    let specification: String?
    let alcoholContent: String?
    let name: String?
    let manufacturer: String?
    let mainIngredient: String?

    enum CodingKeys: String, CodingKey {
        case specification = "규격"
        case alcoholContent = "도수"
        case name = "전통주명"
        case manufacturer = "제조사"
        case mainIngredient = "주원료"
    }
}

extension TraditionalLiquorDTO {
    func toDomain() -> TraditionalLiquor {
        return .init(
            name: name ?? "알수없음",
            alcoholContent: "\(alcoholContent ?? "0") 도",
            specification: specification ?? "알수없음",
            mainIngredient: mainIngredient ?? "알수없음",
            manufacturer: manufacturer ?? "알수없음"
        )
    }
}
