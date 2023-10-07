//
//  StoreVO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

struct StoreVO: Equatable {
    let placeName: String
    let distance: String
    let placeURL: String
    let categoryName: String
    let addressName: String
    let roadAddressName: String
    let id: String
    let phone: String?
    let x: Double
    let y: Double
    let categoryType: CategoryType
    var rate: Int
    var bookmark: Bool
}
