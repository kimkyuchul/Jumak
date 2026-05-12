//
//  AlcoholSearchSection.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import Foundation

struct AlcoholSearchSection: Hashable {
    let letter: Character
    var items: [AlcoholSearchItem]

    static func == (lhs: AlcoholSearchSection, rhs: AlcoholSearchSection) -> Bool {
        lhs.letter == rhs.letter
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(letter)
    }
}

enum AlcoholSearchItem: Hashable {
    case alcohol(AlcoholVO)
}
