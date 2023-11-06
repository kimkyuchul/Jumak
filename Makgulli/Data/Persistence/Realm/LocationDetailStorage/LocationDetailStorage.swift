//
//  LocationDetailStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RealmSwift
import RxSwift

protocol LocationDetailStorage: AnyObject {
    func createStore(_ store: StoreVO) -> Completable
    func updateStore(_ store: StoreVO) -> Completable
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO?
    func deleteStore(_ store: StoreVO) -> Completable
    func checkContainsStore(_ id: String) -> Bool
    func shouldUpdateStore(_ store: StoreVO) -> Bool
}

final class DefaultLocationDetailStorage: BaseRealmStorage, LocationDetailStorage {
    
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
                    storeObject.bookmarkDate = store.bookmarkDate
                    storeObject.rate = store.rate
                    storeObject.categoryType = store.categoryType
                    self.realm.add(storeObject, update: .modified)
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    // WriteEpisode -> LocationDetail로 Dismiss될 때 LocationDetail의 viewWillAppear에서 Episode 정보를 업데이트
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO? {
        do {
            var updatedStore = store
            
            try realm.write {
                if let storeTable = realm.objects(StoreTable.self).filter("id == %@", updatedStore.id).first {
                    
                    var episodeVOList = [EpisodeVO]()
                    
                    let episodeVOArray = storeTable.episode.map { storeObject in
                        let episodeVO = EpisodeVO(
                            id: storeObject._id.stringValue,
                            date: storeObject.date,
                            comment: storeObject.comment,
                            imageURL: storeObject.imageURL,
                            alcohol: storeObject.alcohol,
                            drink: storeObject.drink,
                            drinkQuantity: storeObject.drinkQuantity)
                        
                        return episodeVO
                    }
                    
                    episodeVOList.append(contentsOf: episodeVOArray)
                    updatedStore.episode = episodeVOList
                }
            }
            
            return updatedStore
        } catch {
            print("Error updating store item: \(error)")
            return nil
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
    
    func checkContainsStore(_ id: String) -> Bool {
        let result = realm.objects(StoreTable.self).filter("id == %@", id)
        return !result.isEmpty
    }
    
    func shouldUpdateStore(_ store: StoreVO) -> Bool {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: store.id
        ) else { return false }
        
        if store.rate != storeObject.rate || store.bookmark != storeObject.bookmark || store.bookmarkDate != storeObject.bookmarkDate {
            return true
        }
        
        return false
    }
}
