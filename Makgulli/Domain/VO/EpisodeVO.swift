//
//  EpisodeVO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/06.
//

import Foundation

struct EpisodeVO: Equatable, Hashable {
    let id: String
    let date: Date
    let comment: String
    let imageURL: String
    let alcohol: String
    let drink: Double
    let drinkQuantity: QuantityType
}
