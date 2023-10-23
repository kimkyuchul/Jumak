//
//  FavoriteViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/17.
//

import Foundation

import RxRelay
import RxSwift

final class FavoriteViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    private var defaultRealmRepository = DefaultRealmRepository()
    private lazy var defaultFavoriteUseCase = DefaultFavoriteUseCase(realmRepository: defaultRealmRepository!)
        
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewDidAppearEvent: Observable<Void>
        let didSelectCategoryFilterButton: Observable<CategoryFilterType>
        let didSelectReverseFilterButton: Observable<Void>
    }
    
    struct Output {
        let storeList = PublishRelay<([StoreVO], FilterType, Bool)>()
        let filterType = BehaviorRelay<FilterType>(value: .recentlyAddedBookmark)
        let categoryfilterType = BehaviorRelay<CategoryFilterType>(value: .all)
        let isLoding = BehaviorRelay<Bool>(value: false)
    }

    func transform(input: Input) -> Output {
        let output = Output()
        
        let filterTypes = Observable.combineLatest(output.filterType, output.categoryfilterType)

        input.viewWillAppearEvent
            .take(1)
            .withLatestFrom(filterTypes)
            .withUnretained(self)
            .subscribe(onNext: { owner, filterTypes in
                let (filterType, categoryFilter) = filterTypes
                
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
            })
            .disposed(by: disposeBag)
        
        input.viewDidAppearEvent
            .skip(1)
            .withLatestFrom(filterTypes)
            .withUnretained(self)
            .subscribe(onNext: { owner, filterTypes in
                let (filterType, categoryFilter) = filterTypes
                
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
            })
            .disposed(by: disposeBag)
        
        let didSelectCategoryFilterButton = input.didSelectCategoryFilterButton
            .share()
        
        didSelectCategoryFilterButton
            .withLatestFrom(output.filterType) { categoryFilter, filterType in
                return (categoryFilter, filterType)
            }
            .withUnretained(self)
            .bind(onNext: { owner, filterTypes in
                let (categoryFilter, filterType) = filterTypes
                output.categoryfilterType.accept(categoryFilter)
                
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
            })
            .disposed(by: disposeBag)
        
        input.didSelectReverseFilterButton
            .withLatestFrom(filterTypes)
            .withUnretained(self)
            .subscribe(onNext: { owner, filterTypes in
                let (filterType, categoryFilter) = filterTypes
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
            })
            .disposed(by: disposeBag)
            
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        NotificationCenterManager.filterStore.addObserver()
            .compactMap { $0 as? FilterType }
            .withLatestFrom(output.categoryfilterType)  { filterType, categoryfilterType in
                return (filterType, categoryfilterType)
            }
            .withUnretained(self)
            .bind(onNext: { owner, filterTypes in
                let (filterType, categoryFilter) = filterTypes
                output.filterType.accept(filterType)
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
            })
            .disposed(by: disposeBag)
        
        defaultFavoriteUseCase.filterStore
            .bind(to: output.storeList)
            .disposed(by: disposeBag)
        
        defaultFavoriteUseCase.isLoding
            .bind(to: output.isLoding)
            .disposed(by: disposeBag)
    }
}
