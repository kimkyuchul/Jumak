//
//  SearchLocationVO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

struct SearchLocationVO {
    let meta: MetaVO
    let documents: [DocumentVO]
}

struct MetaVO {
    let is_end: Bool
}

struct DocumentVO {
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
}
