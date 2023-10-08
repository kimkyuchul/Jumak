//
//  DefaultRealmRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

import RxSwift
import RealmSwift

protocol RealmRepository {
    func createBookmark(_ store: StoreVO) -> Completable
    func checkContainsStore(id: String) -> Bool
}

final class DefaultRealmRepository: RealmRepository {
    private let realm: Realm
    
    init?() {
        guard let realm = try? Realm() else { return nil }
        self.realm = realm
        
        if let fileURL = realm.configuration.fileURL {
            print("Realm fileURL \(String(describing: fileURL))")
        }
    }

    func createBookmark(_ store: StoreVO) -> Completable {
        return Completable.create { completable in
            do {
                try self.realm.write {
                    self.realm.add(store.makeStoreTable())
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func checkContainsStore(id: String) -> Bool {
        let result = realm.objects(StoreTable.self).filter("id == %@", id)
        return !result.isEmpty
    }
}

private extension StoreVO {
    func makeStoreTable() -> StoreTable {
        let storeTable = StoreTable(id: self.id,
                                    placeName: self.placeName,
                                    distance: self.distance,
                                    placeURL: self.placeURL,
                                    categoryName: self.categoryName,
                                    addressName: self.addressName,
                                    roadAddressName: self.roadAddressName,
                                    phone: self.phone,
                                    x: self.x,
                                    y: self.y,
                                    categoryType: self.categoryType,
                                    rate: self.rate,
                                    bookmark: self.bookmark)
        return storeTable
    }
}
