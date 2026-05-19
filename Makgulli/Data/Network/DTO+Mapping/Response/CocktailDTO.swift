//
//  CocktailDTO.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import Foundation

// TheCocktailDB의 drinks 필드는 [Drink] | "no data found" 문자열 | null 3종으로 변동.
// 여기서 모두 흡수해 상위는 항상 [CocktailDTO]만 본다.
struct CocktailSearchResponseDTO: Decodable {
    let drinks: [CocktailDTO]

    private enum CodingKeys: String, CodingKey { case drinks }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.drinks = (try? container.decode([CocktailDTO].self, forKey: .drinks)) ?? []
    }
}

struct CocktailDTO: Decodable {
    let idDrink: String?
    let strDrink: String?
    let strCategory: String?
    let strAlcoholic: String?
    let strGlass: String?
    let strDrinkThumb: String?
    let strInstructions: String?
}

extension CocktailDTO {
    func toDomain() -> AlcoholVO {
        AlcoholVO(
            id: idDrink ?? "",
            name: strDrink ?? "",
            category: strCategory ?? "",
            alcoholic: strAlcoholic ?? "",
            glass: strGlass ?? "",
            thumbnailURL: strDrinkThumb ?? "",
            instructions: strInstructions ?? ""
        )
    }
}
