//
//  EpisodeTable.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/08.
//

import Foundation

import RealmSwift

final class EpisodeTable: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var date: String
    @Persisted var comment: String
    @Persisted var imageURL: String
    @Persisted var alcohol: String
    @Persisted var mixedAlcohol: String
    @Persisted var drink: Double
    @Persisted(originProperty: "episode") var episode: LinkingObjects<StoreTable>
    
    convenience init(date: String, comment: String, imageURL: String, alcohol: String, mixedAlcohol: String, drink: Double) {
        self.init()
        self.date = date
        self.comment = comment
        self.imageURL = imageURL
        self.alcohol = alcohol
        self.mixedAlcohol = mixedAlcohol
        self.drink = drink
    }
}

extension EpisodeTable {
    func toDomain() -> EpisodeVO {
        return EpisodeVO(id: _id.stringValue, date: date, comment: comment, imageURL: imageURL, alcohol: alcohol, mixedAlcohol: mixedAlcohol, drink: drink)
    }
}
