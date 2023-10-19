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
        let didSelectReverseFilterButton: Observable<Void>
    }
    
    struct Output {
        let storeList = PublishRelay<([StoreVO], FilterType, Bool)>()
        let filterType = BehaviorRelay<FilterType>(value: .recentlyAddedBookmark)
    }

    func transform(input: Input) -> Output {
        let output = Output()

        input.viewWillAppearEvent
            .withLatestFrom(output.filterType)
            .withUnretained(self)
            .subscribe(onNext: { owner, filterType in
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter)
            })
            .disposed(by: disposeBag)
        
        input.didSelectReverseFilterButton
            .withLatestFrom(output.filterType)
            .withUnretained(self)
            .bind(onNext: { owner, filterType in
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter)
            })
            .disposed(by: disposeBag)
            
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        NotificationCenterManager.filterStore.addObserver()
            .compactMap { $0 as? FilterType }
            .withUnretained(self)
            .bind(onNext: { owner, filterType in
                output.filterType.accept(filterType)
                owner.defaultFavoriteUseCase.fetchFilterStore(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter)
            })
            .disposed(by: disposeBag)
        
        defaultFavoriteUseCase.filterStore
            .bind(to: output.storeList)
            .disposed(by: disposeBag)
    }
}
