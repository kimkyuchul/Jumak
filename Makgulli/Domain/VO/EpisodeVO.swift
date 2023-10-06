//
//  EpisodeVO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/06.
//

import Foundation

struct EpisodeVO: Hashable {
    let uuid : String = UUID().uuidString
    let date: String
    let title: String
    let content: String
    let imageURL: String
    let alcohol: String
    let mixedAlcohol: String
    let drink: Double
}
