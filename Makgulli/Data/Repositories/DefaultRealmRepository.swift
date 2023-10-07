//
//  DefaultRealmRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

import RealmSwift

protocol RealmRepository {
    func saveBookmarkStore(store: StoreVO) throws
    func checkContainsStore(id: String) -> Bool
}

final class DefaultRealmRepository: RealmRepository {
    let realm = try? Realm()
    
    enum RealmError: Error {
        case saveBookmarkStore(description: String)
    }
    
    init() {
        if let fileURL = realm?.configuration.fileURL {
            print("Realm fileURL \(String(describing: fileURL))")
        }
    }
    
    func saveBookmarkStore(store: StoreVO) throws {
        guard let realm else { return }
        
        let storeTable = StoreTable(id: store.id,
                                    placeName: store.placeName,
                                    distance: store.distance,
                                    placeURL: store.placeURL,
                                    categoryName: store.categoryName,
                                    addressName: store.addressName,
                                    roadAddressName: store.roadAddressName,
                                    phone: store.phone,
                                    x: store.x,
                                    y: store.y,
                                    categoryType: store.categoryType,
                                    rate: store.rate)
        do {
            try realm.write {
                realm.add(storeTable)
            }
        } catch {
            throw RealmError.saveBookmarkStore(description: error.localizedDescription)
        }
    }
    
    func checkContainsStore(id: String) -> Bool {
        guard let realm else { return false }
        
        let result = realm.objects(StoreTable.self).where {
            $0.id == id
        }
        return result.isEmpty
    }
}
