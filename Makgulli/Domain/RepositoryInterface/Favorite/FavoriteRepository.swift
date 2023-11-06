//
//  FavoriteRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

protocol FavoriteRepository: AnyObject {
    func fetchBookmarkStore(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchBookmarkStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
    func fetchStoreSortedByName(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
}
