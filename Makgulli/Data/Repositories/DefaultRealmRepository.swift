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
    func createStoreTable(_ store: StoreTable) -> Completable
    func createStore(_ store: StoreVO) -> Completable
    func updateStore(_ store: StoreVO) -> Completable
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable
    func updateStoreEpisode(store: StoreVO) -> StoreVO?
    func updateStoreCellObservable(index: Int, storeList: [StoreVO]) -> Single<StoreVO>
    func updateStoreCell(store: StoreVO) -> StoreVO?
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
    
    func createStoreTable(_ store: StoreTable) -> Completable {
        return Completable.create { completable in
            do {
                try self.realm.write {
                    self.realm.add(store)
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
                    self.realm.add(storeObject, update: .modified)
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    // willDisplayCell에서 그려질 셀에 대해 필터링을 진행하는 메서드 ex) 다른뷰 이동 후 다시 재진입 시
    func updateStoreCellObservable(index: Int, storeList: [StoreVO]) -> Single<StoreVO> {
        return Single.create { single in
            var store = storeList[index]
            
            do {
                try self.realm.write {
                    let storeTable = self.realm.objects(StoreTable.self).where {
                        $0.id == store.id
                    }.first
                    
                    if let storeTable {
                        store.bookmark = storeTable.bookmark
                        store.rate = storeTable.rate
                    } else {
                        store.bookmark = false
                        store.rate = 0
                    }
                }
                
                single(.success(store))
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // rx.modelSelected, rx.items에서 현재 그려진 셀에 대해 필터링을 진행하는 메서드
    func updateStoreCell(store: StoreVO) -> StoreVO? {
        do {
            var updatedStore = store
            
            try realm.write {
                if let storeTable = realm.objects(StoreTable.self).filter("id == %@", updatedStore.id).first {
                    updatedStore.bookmark = storeTable.bookmark
                    updatedStore.rate = storeTable.rate
                }
            }
            
            return updatedStore
        } catch {
            print("Error updating store item: \(error)")
            return nil
        }
    }
    
    // 기존에 있던 store에 에피소드를 append
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: id
        ) else { return .empty() }
        
        return Completable.create { completable in
            do {
                try self.realm.write {
                    storeObject.episode.append(episode)
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
    func updateStoreEpisode(store: StoreVO) -> StoreVO? {
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
    
    func checkContainsStore(id: String) -> Bool {
        let result = realm.objects(StoreTable.self).filter("id == %@", id)
        return !result.isEmpty
    }
    
    func shouldUpdateStore(_ store: StoreVO) -> Bool {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: store.id
        ) else { return false }
        
        if store.rate != storeObject.rate || store.bookmark != storeObject.bookmark {
            return true
        }
        
        return false
    }
}

extension StoreVO {
    func makeStoreTable() -> StoreTable {
        let episodeList = List<EpisodeTable>()
        
        let episodeTableArray = self.episode.map { episodeVO in
            let episodeTable = EpisodeTable()
            episodeTable.comment = episodeVO.comment
            episodeTable.date = episodeVO.date
            episodeTable.alcohol = episodeVO.alcohol
            episodeTable.imageURL = episodeVO.imageURL
            episodeTable.drink = episodeVO.drink
            episodeTable.drinkQuantity = episodeVO.drinkQuantity
            return episodeTable
        }
        
        episodeList.append(objectsIn: episodeTableArray)
        
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
                                    bookmark: self.bookmark,
                                    episode: episodeList)
        return storeTable
    }
}

extension EpisodeVO {
    func makeEpisodeTable() -> EpisodeTable {
        let episodeTable = EpisodeTable(date: self.date,
                                        comment: self.comment,
                                        imageURL: self.imageURL,
                                        alcohol: self.alcohol,
                                        drink: self.drink,
                                        drinkQuantity: self.drinkQuantity)
        return episodeTable
    }
}
