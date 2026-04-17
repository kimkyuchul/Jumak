//
//  LocationViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

final class LocationViewModel: ViewModelType, Coordinatable {
    weak var coordinator: LocationCoordinator?
    var disposeBag: DisposeBag = .init()
    
    private let searchLocationUseCase: SearchLocationUseCase
    private let locationUseCase: LocationUseCase
    private var storeList: [StoreVO] = []
    var categoryType = BehaviorRelay<CategoryType>(value: .makgulli)
    private var currentLocation = PublishRelay<CLLocationCoordinate2D>()
    private let fetchTrigger = PublishRelay<FetchParams>()
    
    init(
        searchLocationUseCase: SearchLocationUseCase,
        locationUseCase: LocationUseCase
    ) {
        self.searchLocationUseCase = searchLocationUseCase
        self.locationUseCase = locationUseCase
    }
    
    deinit {
        print("Deinit LocationViewModel")
    }
    
    private struct FetchParams {
        let query: String
        let x: String
        let y: String
        let page: Int
        let display: Int
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillAppearEvent: Observable<Void>
        let didSelectQuestionButton: Observable<Void>
        let willDisplayCell: Observable<IndexPath>
        let didSelectMarker: Observable<Int?>
        let didSelectCategoryCell: Observable<IndexPath>
        let changeMapLocation: Observable<CLLocationCoordinate2D>
        let didSelectRefreshButton: Observable<Void>
        let didSelectUserLocationButton: Observable<Void>
        let didScrollStoreCollectionView: Observable<Int?>
        let didSelectStoreItem: Observable<StoreVO>
    }
    
    struct Output {
        let storeList = PublishRelay<[StoreVO]>()
        let selectedMarkerIndex = PublishRelay<Int?>()
        let setCameraPosition = PublishRelay<(Double, Double)>()
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        let currentUserAddress = PublishRelay<String>()
        let authorizationAlertShouldShow = BehaviorRelay<Bool>(value: false)
        let reSearchButtonHidden = PublishRelay<Bool>()
        let storeCollectionViewDataSource = BehaviorRelay<[StoreVO]>(value: [])
        let storeEmptyViewHidden = PublishRelay<Bool>()
        let showErrorAlert = PublishRelay<Error>()
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(with: self) { owner, _ in
                owner.locationUseCase.checkLocationAuthorization()
                owner.locationUseCase.checkAuthorization()
                owner.locationUseCase.observeUserLocation()
            }
            .disposed(by: disposeBag)
        
        input.didSelectQuestionButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.startQuestion()
            }
            .disposed(by: disposeBag)
        
        let didSelectMarker = input.didSelectMarker
            .share()
        
        didSelectMarker
            .bind(to: output.selectedMarkerIndex)
            .disposed(by: disposeBag)
        
        didSelectMarker
            .bind(with: self) { owner, index in
                guard let index = index else { return }
                let store = owner.storeList[index]
                output.setCameraPosition.accept((store.y, store.x))
            }
            .disposed(by: disposeBag)
        
        input.didSelectCategoryCell
            .withLatestFrom(currentLocation) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let (indexPath, location) = tuple
                let categoryType = CategoryType.allCases[indexPath.row]
                
                output.reSearchButtonHidden.accept(true)
                owner.categoryType.accept(categoryType)
                owner.fetchTrigger.accept(
                    FetchParams(query: categoryType.rawValue, x: location.x, y: location.y, page: 1, display: 30)
                )
            }
            .disposed(by: disposeBag)
        
        input.changeMapLocation
            .bind(with: self) { owner, coordinate in
                output.reSearchButtonHidden.accept(false)
                owner.currentLocation.accept(coordinate)
            }
            .disposed(by: disposeBag)
        
        let didSelectRefreshButton = input.didSelectRefreshButton
            .withLatestFrom(Observable.combineLatest(self.currentLocation, self.categoryType))
            .share()
        
        didSelectRefreshButton
            .bind(with: self) { owner, pair in
                let (location, categoryType) = pair
                output.reSearchButtonHidden.accept(true)
                owner.fetchTrigger.accept(
                    FetchParams(query: categoryType.rawValue, x: location.x, y: location.y, page: 1, display: 30)
                )
            }
            .disposed(by: disposeBag)
        
        didSelectRefreshButton
            .withUnretained(self)
            .flatMapLatest { owner, pair -> Observable<String> in
                let (location, _) = pair
                return owner.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation)
                    .catchAndReturn("알 수 없는 지역입니다.")
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
        
        input.didSelectUserLocationButton
            .bind(with: self) { owner, _ in
                output.reSearchButtonHidden.accept(true)
                owner.locationUseCase.startUpdatingLocation()
            }
            .disposed(by: disposeBag)
        
        input.didScrollStoreCollectionView
            .distinctUntilChanged()
            .bind(with: self) { owner, percentVisible in
                guard let index = percentVisible else { return }
                let store = owner.storeList[index]
                output.setCameraPosition.accept((store.y, store.x))
                output.selectedMarkerIndex.accept(index)
            }
            .disposed(by: disposeBag)
        
        input.didSelectStoreItem
            .bind(with: self) { owner, store in
                owner.coordinator?.startLocationDetail(store)
            }
            .disposed(by: disposeBag)
        
        bindFetchPipeline(output: output)
        bindWillDisplayUpdate(input: input, output: output)
        bindLocationUpdates(output: output)
        bindCollectionViewDataSource(output: output)
        
        return output
    }
    
    // MARK: - Bindings
    
    /// fetchTrigger → UseCase 호출 → isLoading 토글 + 성공/에러 분기를 한 스트림에서 원자적으로 처리
    private func bindFetchPipeline(output: Output) {
        fetchTrigger
            .do(onNext: { _ in output.isLoading.accept(true) })
            .flatMapLatest { [weak self] params -> Observable<Event<SearchLocationVO>> in
                guard let self = self else { return .empty() }
                return self.searchLocationUseCase
                    .fetchLocation(query: params.query, x: params.x, y: params.y, page: params.page, display: params.display)
                    .asObservable()
                    .materialize()
            }
            .do(onNext: { _ in output.isLoading.accept(false) })
            .subscribe(onNext: { event in
                switch event {
                case .next(let vo):
                    output.storeEmptyViewHidden.accept(!vo.stores.isEmpty)
                    output.selectedMarkerIndex.accept(nil)
                    output.storeList.accept(vo.stores)
                case .error(let error):
                    output.showErrorAlert.accept(error)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 셀 노출 시점마다 로컬 저장소에서 갱신된 StoreVO를 가져와 storeList를 부분 업데이트
    private func bindWillDisplayUpdate(input: Input, output: Output) {
        input.viewWillAppearEvent
            .withLatestFrom(input.willDisplayCell)
            .withUnretained(self)
            .flatMapLatest { owner, indexPath -> Observable<(StoreVO, IndexPath)> in
                owner.searchLocationUseCase
                    .updateWillDisplayStoreCell(index: indexPath.row, storeList: owner.storeList)
                    .asObservable()
                    .map { ($0, indexPath) }
                    .catch { error in
                        output.showErrorAlert.accept(error)
                        return .empty()
                    }
            }
            .bind(with: self) { owner, tuple in
                let (updatedStore, indexPath) = tuple
                guard indexPath.row < owner.storeList.count else { return }
                let current = owner.storeList[indexPath.row]
                if owner.shouldUpdateStore(store: updatedStore, visibleStore: current) {
                    owner.storeList[indexPath.row] = updatedStore
                    output.storeList.accept(owner.storeList)
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// LocationUseCase의 위치/권한 스트림을 VM의 Output과 내부 상태로 연결 (위치 갱신 시 재검색 포함)
    private func bindLocationUpdates(output: Output) {
        locationUseCase.locationUpdateSubject
            .withLatestFrom(Observable.combineLatest(output.currentUserLocation, self.categoryType))
            .bind(with: self) { owner, userLocationAndCategoryType in
                let (userLocation, categoryType) = userLocationAndCategoryType
                
                owner.fetchTrigger.accept(
                    FetchParams(query: categoryType.rawValue, x: userLocation.x, y: userLocation.y, page: 1, display: 30)
                )
            }
            .disposed(by: disposeBag)
        
        output.storeList
            .subscribe(with: self) { owner, storeVO in
                owner.storeList = storeVO
            }
            .disposed(by: disposeBag)
        
        let locationCoordinate = locationUseCase.locationCoordinate
            .share()
        
        locationCoordinate
            .bind(with: self) { owner, coordinate in
                owner.currentLocation.accept(coordinate)
            }
            .disposed(by: disposeBag)
        
        locationCoordinate
            .bind(to: output.currentUserLocation)
            .disposed(by: disposeBag)
        
        locationCoordinate
            .withUnretained(self)
            .flatMapLatest { owner, location in
                owner.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation)
                    .catchAndReturn("알 수 없는 지역입니다.")
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
        
        locationUseCase.authorizationDeniedStatus
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
    }
    
    /// storeList와 현재 categoryType을 합쳐 셀용 데이터 소스를 재구성
    private func bindCollectionViewDataSource(output: Output) {
        Observable.combineLatest(output.storeList, self.categoryType)
            .map { storeList, categoryType in
                return storeList.map { store in
                    return StoreVO(
                        placeName: store.placeName,
                        distance: store.distance,
                        placeURL: store.placeURL,
                        categoryName: store.categoryName,
                        addressName: store.addressName,
                        roadAddressName: store.roadAddressName,
                        id: store.id,
                        phone: store.phone,
                        x: store.x,
                        y: store.y,
                        categoryType: categoryType,
                        rate: store.rate,
                        bookmark: store.bookmark,
                        bookmarkDate: store.bookmarkDate,
                        episode: store.episode
                    )
                }
            }
            .bind(to: output.storeCollectionViewDataSource)
            .disposed(by: disposeBag)
    }
}

extension LocationViewModel {
    func updateStoreCell(_ store: StoreVO) -> StoreVO? {
        return searchLocationUseCase.updateStoreCell(store)
    }
    
    private func shouldUpdateStore(store: StoreVO, visibleStore: StoreVO) -> Bool {
        return store.rate != visibleStore.rate || store.bookmark != visibleStore.bookmark || store.episode != visibleStore.episode
    }
}
