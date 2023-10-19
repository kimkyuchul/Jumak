//
//  FavoriteUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import Foundation

import RxSwift

final class DefaultFavoriteUseCase {
    
    private let realmRepository: RealmRepository
    private let disposebag = DisposeBag()
    
    var updateEpisodeListState = PublishSubject<Void>()
    var errorSubject = PublishSubject<Error>()
    var filterStore = PublishSubject<([StoreVO], FilterType, ReverseFilterType)>()
    
    
    init(
        realmRepository: RealmRepository
    ) {
        self.realmRepository = realmRepository
    }
    
    func fetchFilterStore(filterType: FilterType, reverseFilter: ReverseFilterType) {
        filterStore(filterType: filterType, reverseFilter: reverseFilter)
            .subscribe { [weak self] result in
                switch result {
                case .success(let storeList):
                    self?.filterStore.onNext((storeList, filterType, reverseFilter))
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposebag)
    }
    
    private func filterStore(filterType: FilterType, reverseFilter: ReverseFilterType) -> Single<[StoreVO]> {
        let isReversed = reverseFilter != .none

        switch filterType {
        case .recentlyAddedBookmark:
            return realmRepository.fetchBookmarkStore(sortAscending: isReversed)

        case .sortByUpRating:
            return realmRepository.fetchStoreSortedByRating(sortAscending: isReversed)

        case .bookmarkSortByUpRating:
            return realmRepository.fetchBookmarkStoreSortedByRating(sortAscending: isReversed)

        case .sortByDescendingEpisodeCount:
            return realmRepository.fetchStoreSortedByEpisodeCount(sortAscending: isReversed)

        case .bookmarkSortByDescendingEpisodeCount:
            return realmRepository.fetchBookmarkStoreSortedByEpisodeCount(sortAscending: isReversed)

        case .sortByName:
            return realmRepository.fetchStoreSortedByName(sortAscending: !isReversed)
        }
    }
}
