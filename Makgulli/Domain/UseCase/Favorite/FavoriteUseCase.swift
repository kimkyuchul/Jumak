//
//  FavoriteUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import Foundation

import RxSwift

protocol FavoriteUseCase: AnyObject {
    func fetchFilterStore(filterType: FilterType, reverseFilter: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]>
}

final class DefaultFavoriteUseCase: FavoriteUseCase {
    private let favoriteRepository: FavoriteRepository

    init(favoriteRepository: FavoriteRepository) {
        self.favoriteRepository = favoriteRepository
    }

    func fetchFilterStore(filterType: FilterType, reverseFilter: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        switch filterType {
        case .recentlyAddedBookmark:
            return favoriteRepository.fetchBookmarkStore(sortAscending: reverseFilter, categoryFilter: categoryFilter)
        case .sortByUpRating:
            return favoriteRepository.fetchStoreSortedByRating(sortAscending: reverseFilter, categoryFilter: categoryFilter)
        case .bookmarkSortByUpRating:
            return favoriteRepository.fetchBookmarkStoreSortedByRating(sortAscending: reverseFilter, categoryFilter: categoryFilter)
        case .sortByDescendingEpisodeCount:
            return favoriteRepository.fetchStoreSortedByEpisodeCount(sortAscending: reverseFilter, categoryFilter: categoryFilter)
        case .bookmarkSortByDescendingEpisodeCount:
            return favoriteRepository.fetchBookmarkStoreSortedByEpisodeCount(sortAscending: reverseFilter, categoryFilter: categoryFilter)
        case .sortByName:
            return favoriteRepository.fetchStoreSortedByName(sortAscending: !reverseFilter, categoryFilter: categoryFilter)
        }
    }
}
