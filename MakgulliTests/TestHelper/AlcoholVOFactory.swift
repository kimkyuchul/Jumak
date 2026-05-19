//
//  AlcoholVOFactory.swift
//  MakgulliTests
//
//  Created by 김규철 on 2026/05/11.
//

import Foundation
@testable import Makgulli

enum AlcoholVOFactory {
    static func make(
        id: String = "test-id",
        name: String = "Test Drink",
        category: String = "Cocktail",
        alcoholic: String = "Alcoholic",
        glass: String = "Cocktail glass",
        thumbnailURL: String = "",
        instructions: String = ""
    ) -> AlcoholVO {
        AlcoholVO(
            id: id,
            name: name,
            category: category,
            alcoholic: alcoholic,
            glass: glass,
            thumbnailURL: thumbnailURL,
            instructions: instructions
        )
    }
}
