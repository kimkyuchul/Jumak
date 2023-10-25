//
//  RealmRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/25.
//

import Foundation

import RxSwift

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
