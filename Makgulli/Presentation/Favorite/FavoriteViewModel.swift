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
    
    var defaultRealmRepository = DefaultRealmRepository()
    private lazy var defaultFavoriteUseCase = DefaultFavoriteUseCase(realmRepository: defaultRealmRepository!)
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let didSelectReverseFilterButton: Observable<ReverseFilterType>
    }
    
    struct Output {
        let storeList = PublishRelay<([StoreVO], FilterType, ReverseFilterType)>()
        let filterType = BehaviorRelay<FilterType>(value: .recentlyAddedBookmark)
        let reverseFilterType = BehaviorRelay<ReverseFilterType>(value: .none)
    }

    func transform(input: Input) -> Output {
        let output = Output()
        
        let filterTypes = Observable.combineLatest(output.filterType, output.reverseFilterType)

        // 리펙토링 필요 -> viewWillAppear마다 fetch 불리는건 매우 안좋음
        input.viewWillAppearEvent
            .withLatestFrom(filterTypes)
            .withUnretained(self)
            .subscribe(onNext: { owner, filterType in
                let (filterType, reverseFilterType) = filterType
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: reverseFilterType)
            })
            .disposed(by: disposeBag)
        
        let didSelectReverseFilterButton = input.didSelectReverseFilterButton
            .share()
            .distinctUntilChanged()
        
        didSelectReverseFilterButton
            .bind(to: output.reverseFilterType)
            .disposed(by: disposeBag)
        
        didSelectReverseFilterButton
            .withLatestFrom(output.filterType) { reverseFilterType, filterType in
                return (reverseFilterType, filterType)
            }
            .withUnretained(self)
            .bind(onNext: { owner, filterTypes in
                let (reverseFilterType, filterType) = filterTypes
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: reverseFilterType)
            })
            .disposed(by: disposeBag)
        
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        NotificationCenterManager.filterStore.addObserver()
            .compactMap { $0 as? FilterType }
            .withLatestFrom(output.reverseFilterType) { filterType, reverseFilterType in
                return (filterType, reverseFilterType)
            }
            .withUnretained(self)
            .bind(onNext: { owner, filterTypes in
                let (filterType, reverseFilterType) = filterTypes
                
                output.filterType.accept(filterType)
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: reverseFilterType)
            })
            .disposed(by: disposeBag)
        
        defaultFavoriteUseCase.filterStore
            .bind(to: output.storeList)
            .disposed(by: disposeBag)
    }
}

