//
//  DefaultFavoriteRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

final class DefaultFavoriteRepository: FavoriteRepository {
    private let favoriteStorage: DefaultFavoriteStorage
    
    enum FavoriteError: Error {
        case InvaildError
    }
    
    init(favoriteStorage: DefaultFavoriteStorage) {
        self.favoriteStorage = favoriteStorage
    }
    
    func fetchBookmarkStore(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FavoriteError.InvaildError))
                return Disposables.create()
            }
            let storeValue = self.favoriteStorage.fetchBookmarkStore(sortAscending: sortAscending)
                .filter { storeValue in
                    return self.filterStoreTable(storeTable: storeValue, with: categoryFilter)
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FavoriteError.InvaildError))
                return Disposables.create()
            }
            let storeValue = self.favoriteStorage.fetchStoreSortedByRating(sortAscending: sortAscending)
                .filter { storeValue in
                    return self.filterStoreTable(storeTable: storeValue, with: categoryFilter)
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchBookmarkStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FavoriteError.InvaildError))
                return Disposables.create()
            }
            let storeValue = self.favoriteStorage.fetchBookmarkStoreSortedByRating(sortAscending: sortAscending)
                .filter { storeValue in
                    return self.filterStoreTable(storeTable: storeValue, with: categoryFilter)
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FavoriteError.InvaildError))
                return Disposables.create()
            }
            let storeValue = self.favoriteStorage.fetchStoreSortedByEpisodeCount(sortAscending: sortAscending)
                .filter { storeTable in
                         return storeTable.episode.count > 0
                     }
                .sorted { (store1, store2) in
                    let episodeCount1 = store1.episode.count
                    let episodeCount2 = store2.episode.count
                    
                    if sortAscending {
                        return episodeCount1 < episodeCount2
                    } else {
                        return episodeCount1 > episodeCount2
                    }
                }
                .filter { storeValue in
                    return self.filterStoreTable(storeTable: storeValue, with: categoryFilter)
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
    
    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FavoriteError.InvaildError))
                return Disposables.create()
            }
            let storeValue = self.favoriteStorage.fetchBookmarkStoreSortedByEpisodeCount(sortAscending: sortAscending)
                .filter { storeTable in
                         return storeTable.episode.count > 0
                     }
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
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.failure(FavoriteError.InvaildError))
                return Disposables.create()
            }
            let storeValue = self.favoriteStorage.fetchStoreSortedByName(sortAscending: sortAscending)
                .filter { storeValue in
                    return self.filterStoreTable(storeTable: storeValue, with: categoryFilter)
                }
                .map { $0.toDomain() } as [StoreVO]
            
            single(.success(storeValue))
            return Disposables.create()
        }
    }
}

extension DefaultFavoriteRepository {
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
