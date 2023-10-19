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
    
    var errorSubject = PublishSubject<Error>()
    var filterStore = PublishSubject<([StoreVO], FilterType, Bool)>()
    
    init(
        realmRepository: RealmRepository
    ) {
        self.realmRepository = realmRepository
    }
    
    func fetchFilterStore(filterType: FilterType, reverseFilter: Bool) {
        filterStore(filterType: filterType, reverseFilter: reverseFilter)
            .subscribe { [weak self] result in
                switch result {
                case .success(let storeList):
                    self?.filterStore.onNext((storeList, filterType, reverseFilter))
                case .failure(let error):
                    self?.errorSubject.onNext(error)
                }
            }
            .disposed(by: disposebag)
    }
    
    private func filterStore(filterType: FilterType, reverseFilter: Bool) -> Single<[StoreVO]> {

        switch filterType {
        case .recentlyAddedBookmark:
            return realmRepository.fetchBookmarkStore(sortAscending: reverseFilter)

        case .sortByUpRating:
            return realmRepository.fetchStoreSortedByRating(sortAscending: reverseFilter)

        case .bookmarkSortByUpRating:
            return realmRepository.fetchBookmarkStoreSortedByRating(sortAscending: reverseFilter)

        case .sortByDescendingEpisodeCount:
            return realmRepository.fetchStoreSortedByEpisodeCount(sortAscending: reverseFilter)

        case .bookmarkSortByDescendingEpisodeCount:
            return realmRepository.fetchBookmarkStoreSortedByEpisodeCount(sortAscending: reverseFilter)

        case .sortByName:
            return realmRepository.fetchStoreSortedByName(sortAscending: !reverseFilter)
        }
    }
}
