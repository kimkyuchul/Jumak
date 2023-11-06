//
//  FavoriteUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import Foundation

import RxSwift

protocol FavoriteUseCase: AnyObject {
    func fetchFilterStore(filterType: FilterType, reverseFilter: Bool, categoryFilter: CategoryFilterType)
    
    var errorSubject: PublishSubject<Error> { get }
    var filterStore: PublishSubject<([StoreVO], FilterType, Bool)> { get }
    var isLoding: PublishSubject<Bool> { get }
}

final class DefaultFavoriteUseCase: FavoriteUseCase {
    
    private let favoriteRepository: FavoriteRepository
    private let disposebag = DisposeBag()
    
    var errorSubject = PublishSubject<Error>()
    var filterStore = PublishSubject<([StoreVO], FilterType, Bool)>()
    var isLoding = PublishSubject<Bool>()
    
    init(
        favoriteRepository: FavoriteRepository
    ) {
        self.favoriteRepository = favoriteRepository
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
