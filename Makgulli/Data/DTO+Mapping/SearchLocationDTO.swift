//
//  SearchLocationDTO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

struct SearchLocationDTO: Decodable {
    let meta: MetaDTO
    let documents: [DocumentDTO]
}

struct MetaDTO: Decodable {
    let is_end: Bool
    let same_name: SearchNameDTO
}

struct SearchNameDTO: Decodable {
    let region: [String]
    let keyword: String
    let selected_region: String
}

struct DocumentDTO: Decodable {
    let placeName: String
    let distance: String
    let placeURL: String
    let categoryName: String
    let addressName: String
    let roadAddressName: String
    let id: String
    let phone: String?
    let categoryGroupCode: String?
    let categoryGroupName: String?
    let x: String
    let y: String
    
    private enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case distance
        case placeURL = "place_url"
        case categoryName = "category_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case id
        case phone
        case categoryGroupCode
        case categoryGroupName
        case x
        case y
    }
}

extension SearchLocationDTO {
    func toDomain() -> SearchLocationVO {
        return SearchLocationVO(meta: meta.toDomain(), documents: documents.map { $0.toDomain() })
    }
}

extension MetaDTO {
    func toDomain() -> MetaVO {
        return MetaVO(is_end: is_end)
    }
}

extension DocumentDTO {
    func toDomain() -> DocumentVO {
        return DocumentVO(placeName: placeName, distance: distance, placeURL: placeURL, categoryName: categoryName, addressName: addressName, roadAddressName: roadAddressName, id: id, phone: phone ?? "전화번호 정보가 없어요.", x: x, y: y)
    }
}
