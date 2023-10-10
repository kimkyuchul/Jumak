//
//  StoreTable.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

import RealmSwift

final class StoreTable: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var placeName: String
    @Persisted var distance: String
    @Persisted var placeURL: String
    @Persisted var categoryName: String
    @Persisted var addressName: String
    @Persisted var roadAddressName: String
    @Persisted var phone: String?
    @Persisted var x: Double
    @Persisted var y: Double
    @Persisted var categoryType: CategoryType
    @Persisted var rate: Int
    @Persisted var date: Date
    @Persisted var bookmark: Bool
    @Persisted var episode: List<EpisodeTable>
    
    convenience init(id: String, placeName: String, distance: String, placeURL: String, categoryName: String, addressName: String, roadAddressName: String, phone: String?, x: Double, y: Double, categoryType: CategoryType, rate: Int, bookmark: Bool, episode: List<EpisodeTable>) {
        self.init()
        self.id = id
        self.placeName = placeName
        self.distance = distance
        self.placeURL = placeURL
        self.categoryName = categoryName
        self.addressName = addressName
        self.roadAddressName = roadAddressName
        self.phone = phone
        self.x = x
        self.y = y
        self.categoryType = categoryType
        self.rate = rate
        self.date = Date()
        self.bookmark = bookmark
        self.episode = episode
    }
}

extension StoreTable {
    func toDomain() -> StoreVO {
        return StoreVO(placeName: placeName, distance: distance, placeURL: placeURL, categoryName: categoryName, addressName: addressName, roadAddressName: roadAddressName, id: id, phone: phone ?? StringLiteral.noPhoneNumberMessage, x: x , y: y , categoryType: .makgulli, rate: rate, bookmark: bookmark, episode: episode.map { $0.toDomain() })
    }
}


