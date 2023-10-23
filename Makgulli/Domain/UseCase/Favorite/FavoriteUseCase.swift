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
    var isLoding = PublishSubject<Bool>()
    
    init(
        realmRepository: RealmRepository
    ) {
        self.realmRepository = realmRepository
    }
    
    func fetchFilterStore(filterType: FilterType, reverseFilter: Bool, categoryFilter: CategoryFilterType) {
        filterStore(filterType: filterType, reverseFilter: reverseFilter, categoryFilter: categoryFilter)
            .subscribe { [weak self] result in
                self?.isLoding.onNext(true)
                switch result {
                case .success(let storeList):
                    self?.filterStore.onNext((storeList, filterType, reverseFilter))
                case .failure(let error):
                    self?.errorSubject.onNext(error)
                }
                self?.isLoding.onNext(false)
            }
            .disposed(by: disposebag)
    }
    
    private func filterStore(filterType: FilterType, reverseFilter: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        
        switch filterType {
        case .recentlyAddedBookmark:
            return realmRepository.fetchBookmarkStore(sortAscending: reverseFilter, categoryFilter: categoryFilter)
            
        case .sortByUpRating:
            return realmRepository.fetchStoreSortedByRating(sortAscending: reverseFilter, categoryFilter: categoryFilter)
            
        case .bookmarkSortByUpRating:
            return realmRepository.fetchBookmarkStoreSortedByRating(sortAscending: reverseFilter, categoryFilter: categoryFilter)
            
        case .sortByDescendingEpisodeCount:
            return realmRepository.fetchStoreSortedByEpisodeCount(sortAscending: reverseFilter, categoryFilter: categoryFilter)
            
        case .bookmarkSortByDescendingEpisodeCount:
            return realmRepository.fetchBookmarkStoreSortedByEpisodeCount(sortAscending: reverseFilter, categoryFilter: categoryFilter)
            
        case .sortByName:
            return realmRepository.fetchStoreSortedByName(sortAscending: !reverseFilter, categoryFilter: categoryFilter)
        }
    }
}
