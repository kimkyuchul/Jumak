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
    func createStore(_ store: StoreVO) -> Completable
    func updateStore(_ store: StoreVO) -> Completable
    func deleteStore(_ store: StoreVO) -> Completable
    func checkContainsStore(id: String) -> Bool
    func shouldUpdateStore(_ store: StoreVO) -> Bool
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
    
    func createStore(_ store: StoreVO) -> Completable {
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
    
    func updateStore(_ store: StoreVO) -> Completable {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: store.id
        ) else { return .empty() }
        
        return Completable.create { completable in
            do {
                try self.realm.write {
                    storeObject.bookmark = store.bookmark
                    storeObject.rate = store.rate
                    storeObject.categoryType = store.categoryType
                    
                    storeObject.episode.removeAll()
                    store.episode.forEach { episodeVO in
                        let episodeTable = EpisodeTable(
                            date: episodeVO.date,
                            title: episodeVO.title,
                            content: episodeVO.content,
                            imageURL: episodeVO.imageURL,
                            alcohol: episodeVO.alcohol,
                            mixedAlcohol: episodeVO.mixedAlcohol,
                            drink: episodeVO.drink
                        )
                        storeObject.episode.append(episodeTable)
                    }
                    
                    self.realm.add(storeObject, update: .modified)
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteStore(_ store: StoreVO) -> Completable {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: store.id
        ) else { return .empty() }
        
        return Completable.create { completable in
            do {
                try self.realm.write {
                    self.realm.delete(storeObject)
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
    
    func shouldUpdateStore(_ store: StoreVO) -> Bool {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: store.id
        ) else { return false }
        
        let storeEpisodeIds = Set(store.episode.map { $0.id })
        let realmEpisodeIds = Set(storeObject.episode.map { $0._id.stringValue })

        if store.rate != storeObject.rate || storeEpisodeIds != realmEpisodeIds {
            return true
        }

        return false
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
