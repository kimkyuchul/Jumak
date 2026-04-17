//
//  FavoriteViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/17.
//

import Foundation

import RxRelay
import RxSwift

final class FavoriteViewModel: ViewModelType, Coordinatable {
    weak var coordinator: FavoriteCoordinator?
    var disposeBag: DisposeBag = .init()

    private let favoriteUseCase: FavoriteUseCase
    private let fetchTrigger = PublishRelay<FetchParams>()

    init(
        favoriteUseCase: FavoriteUseCase
    ) {
        self.favoriteUseCase = favoriteUseCase
    }

    private struct FetchParams {
        let filterType: FilterType
        let reverseFilter: Bool
        let categoryFilter: CategoryFilterType
    }

    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewDidAppearEvent: Observable<Void>
        let didSelectAppInfoButton: Observable<Void>
        let didSelectCategoryFilterButton: Observable<CategoryFilterType>
        let didSelectReverseFilterButton: Observable<Void>
        let didSelectStoreItem: Observable<StoreVO>
    }

    struct Output {
        let storeList = PublishRelay<([StoreVO], FilterType, Bool)>()
        let filterType = BehaviorRelay<FilterType>(value: .recentlyAddedBookmark)
        let categoryfilterType = BehaviorRelay<CategoryFilterType>(value: .all)
        let showErrorAlert = PublishRelay<Error>()
        let isLoading = BehaviorRelay<Bool>(value: false)
    }

    func transform(input: Input) -> Output {
        let output = Output()

        let filterTypes = Observable.combineLatest(output.filterType, output.categoryfilterType)

        // 최초 viewWillAppear(1회) + 이후 viewDidAppear(2회차~) → 동일한 fetch 트리거
        Observable.merge(
            input.viewWillAppearEvent.take(1),
            input.viewDidAppearEvent.skip(1)
        )
        .withLatestFrom(filterTypes)
        .bind(onNext: { [fetchTrigger] (filterType, categoryFilter) in
            fetchTrigger.accept(
                FetchParams(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
            )
        })
        .disposed(by: disposeBag)

        input.didSelectAppInfoButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.startAppInfo()
            }
            .disposed(by: disposeBag)

        input.didSelectCategoryFilterButton
            .withLatestFrom(output.filterType) { ($0, $1) }
            .bind(onNext: { [fetchTrigger] (categoryFilter, filterType) in
                output.categoryfilterType.accept(categoryFilter)
                fetchTrigger.accept(
                    FetchParams(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
                )
            })
            .disposed(by: disposeBag)

        input.didSelectReverseFilterButton
            .withLatestFrom(filterTypes)
            .bind(onNext: { [fetchTrigger] (filterType, categoryFilter) in
                fetchTrigger.accept(
                    FetchParams(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
                )
            })
            .disposed(by: disposeBag)

        input.didSelectStoreItem
            .bind(with: self) { owner, store in
                owner.coordinator?.startLocationDetail(store)
            }
            .disposed(by: disposeBag)

        // NotificationCenter를 통한 FilterType 변경 감지
        NotificationCenterManager.filterStore.addObserver()
            .compactMap { $0 as? FilterType }
            .withLatestFrom(output.categoryfilterType) { ($0, $1) }
            .bind(onNext: { [fetchTrigger] (filterType, categoryFilter) in
                output.filterType.accept(filterType)
                fetchTrigger.accept(
                    FetchParams(filterType: filterType, reverseFilter: UserDefaultHandler.reverseFilter, categoryFilter: categoryFilter)
                )
            })
            .disposed(by: disposeBag)

        // fetchTrigger → UseCase 호출 → isLoading 토글 + 성공/에러 분기
        fetchTrigger
            .do(onNext: { _ in output.isLoading.accept(true) })
            .flatMapLatest { [weak self] params -> Observable<Event<([StoreVO], FilterType, Bool)>> in
                guard let self = self else { return .empty() }
                return self.favoriteUseCase
                    .fetchFilterStore(filterType: params.filterType, reverseFilter: params.reverseFilter, categoryFilter: params.categoryFilter)
                    .map { stores in (stores, params.filterType, params.reverseFilter) }
                    .asObservable()
                    .materialize()
            }
            .do(onNext: { _ in output.isLoading.accept(false) })
            .subscribe(onNext: { event in
                switch event {
                case .next(let result):
                    output.storeList.accept(result)
                case .error(let error):
                    output.showErrorAlert.accept(error)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)

        return output
    }
}
