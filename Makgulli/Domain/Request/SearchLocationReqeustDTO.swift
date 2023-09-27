//
//  SearchLocationReqeustDTO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

struct SearchLocationRequestDTO: Encodable {
    let query: String
    let x: String // longitude (경도)
    let y: String // latitude (위도)
    let radius: Int = 20000
    let page: Int
    let display: Int
    let categoryGroupCode: CategoryGroupCode = .restaurant
    
    enum CodingKeys: String, CodingKey {
        case query
        case x
        case y
        case radius
        case page
        case display
        case categoryGroupCode = "category_group_code"
    }
    
    init(query: String, x: String, y: String, page: Int, display: Int) {
        self.query = query
        self.x = x
        self.y = y
        self.page = page
        self.display = display
    }
}

enum CategoryGroupCode: String, Encodable {
    case restaurant = "FD6"
    case cafe = "CE7"
}
