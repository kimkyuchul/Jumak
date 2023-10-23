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
    func fetchBookmarkStore(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchBookmarkStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchStoreSortedByName(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func createStoreTable(_ store: StoreTable) -> Completable
    func createStore(_ store: StoreVO) -> Completable
    func updateStore(_ store: StoreVO) -> Completable
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable
    func updateStoreEpisode(store: StoreVO) -> StoreVO?
    func updateStoreCellObservable(index: Int, storeList: [StoreVO]) -> Single<StoreVO>
    func updateStoreCell(store: StoreVO) -> StoreVO?
    func deleteStore(_ store: StoreVO) -> Completable
    func deleteEpisode(id: String, episodeId: String) -> Completable
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
    
    func fetchBookmarkStore(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { single in
            let storeValue = self.realm.objects(StoreTable.self)
                .sorted(byKeyPath: "bookmarkDate", ascending: sortAscending)
                .filter("bookmark == %@", true)
                .filter { [weak self] storeValue in
                    return self?.filterStoreTable(storeTable: storeValue, with: categoryFilter) ?? true
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
        
    func fetchStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { single in
            let sortProperties = [SortDescriptor(keyPath: "rate", ascending: sortAscending),
                                  SortDescriptor(keyPath: "date", ascending: false)]
            
            let storeValue = self.realm.objects(StoreTable.self)
                .sorted(by: sortProperties)
                .filter("rate != %@", 0)
                .filter { [weak self] storeValue in
                    return self?.filterStoreTable(storeTable: storeValue, with: categoryFilter) ?? true
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchBookmarkStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { single in
            let sortProperties = [SortDescriptor(keyPath: "rate", ascending: sortAscending),
                                  SortDescriptor(keyPath: "date", ascending: false)]
            
            let storeValue = self.realm.objects(StoreTable.self)
                .sorted(by: sortProperties)
                .filter("rate != %@", 0)
                .filter("bookmark == %@", true)
                .filter { [weak self] storeValue in
                    return self?.filterStoreTable(storeTable: storeValue, with: categoryFilter) ?? true
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { single in
            let storeValue = self.realm.objects(StoreTable.self)
                .sorted(byKeyPath: "date", ascending: false)
                .sorted { (store1, store2) in
                    let episodeCount1 = store1.episode.count
                    let episodeCount2 = store2.episode.count
                    
                    if sortAscending {
                        return episodeCount1 < episodeCount2
                    } else {
                        return episodeCount1 > episodeCount2
                    }
                }
                .filter { [weak self] storeValue in
                    return self?.filterStoreTable(storeTable: storeValue, with: categoryFilter) ?? true
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { single in
            let storeValue = self.realm.objects(StoreTable.self)
                .sorted(byKeyPath: "date", ascending: false)
                .filter("bookmark == %@", true)
                .sorted { (store1, store2) in
                    let episodeCount1 = store1.episode.count
                    let episodeCount2 = store2.episode.count
                    
                    if sortAscending {
                        return episodeCount1 < episodeCount2
                    } else {
                        return episodeCount1 > episodeCount2
                    }
                }
                .filter { [weak self] storeValue in
                    return self?.filterStoreTable(storeTable: storeValue, with: categoryFilter) ?? true
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchStoreSortedByName(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { single in
            let storeValue = self.realm.objects(StoreTable.self)
                .sorted(byKeyPath: "placeName", ascending: sortAscending)
                .filter { [weak self] storeValue in
                    return self?.filterStoreTable(storeTable: storeValue, with: categoryFilter) ?? true
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
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
                    updatedStore.bookmarkDate = storeTable.bookmarkDate
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
    
    func deleteEpisode(id: String, episodeId: String) -> Completable {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: id
        ) else { return .empty() }
        
        return Completable.create { completable in
            do {
                try self.realm.write {
                    if let objectId = try? ObjectId(string: episodeId), let episodeTable = self.realm.objects(EpisodeTable.self).filter("_id == %@", objectId).first {
                        if let index = storeObject.episode.firstIndex(of: episodeTable) {
                            storeObject.episode.remove(at: index)
                            self.realm.add(storeObject, update: .modified)
                        }
                    }
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
        
        if store.rate != storeObject.rate || store.bookmark != storeObject.bookmark || store.bookmarkDate != storeObject.bookmarkDate {
            return true
        }
        
        return false
    }
}

extension DefaultRealmRepository {
    private func filterStoreTable(storeTable: StoreTable, with categoryFilter: CategoryFilterType) -> Bool {
        switch categoryFilter {
        case .all:
            return true
        case .makgulli:
            return storeTable.categoryType == .makgulli
        case .pajeon:
            return storeTable.categoryType == .pajeon
        case .bossam:
            return storeTable.categoryType == .bossam
        }
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
                                    episode: episodeList,
                                    bookmarkDate: self.bookmarkDate)
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
