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
    
    init(searchLocationUseCase: SearchLocationUseCase, locationUseCase: LocationUseCase) {
        self.searchLocationUseCase = searchLocationUseCase
        self.locationUseCase = locationUseCase
    }
    
    deinit {
        print("Deinit LocationViewModel")
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
        let isLoding = BehaviorRelay<Bool>(value: false)
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
        
        input.viewWillAppearEvent
            .withLatestFrom(input.willDisplayCell)
            .bind(with: self) { owner, indexPath in
                owner.searchLocationUseCase.updateWillDisplayStoreCell(index: indexPath.row, storeList: owner.storeList)
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
            .withLatestFrom(currentLocation) { index, location in
                return (index, location)
            }
            .bind(with: self) { owner, indexLocation in
                let categoryType = CategoryType.allCases[indexLocation.0.row]
                
                output.reSearchButtonHidden.accept(true)
                owner.categoryType.accept(categoryType)
                owner.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: indexLocation.1.x, y: indexLocation.1.y, page: 1, display: 30)
            }
            .disposed(by: disposeBag)
        
        input.changeMapLocation
            .bind(with: self) { owner, coordinate in
                output.reSearchButtonHidden.accept(false)
                owner.currentLocation.accept(coordinate)
            }
            .disposed(by: disposeBag)
        
        input.didSelectRefreshButton
            .withLatestFrom(Observable.combineLatest(self.currentLocation, self.categoryType))
            .withUnretained(self)
            .flatMap { owner, currentLocationAndCategoryType -> Observable<String> in
                let (currentLocation, categoryType) = currentLocationAndCategoryType
                output.reSearchButtonHidden.accept(true)
                owner.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: currentLocation.x, y: currentLocation.y, page: 1, display: 30)
                
                return owner.locationUseCase.reverseGeocodeLocation(location: currentLocation.convertToCLLocation)
                    .catchAndReturn("알 수 없는 지역입니다.")
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
        
        input.didSelectUserLocationButton
            .withUnretained(self)
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
        
        createOutput(input: input, output: output)
        transformCollectionViewDataSource(input: input, output: output)
        
        return output
    }
    
    private func createOutput(input: Input, output: Output) {
        locationUseCase.locationUpdateSubject
            .withLatestFrom(Observable.combineLatest(output.currentUserLocation, self.categoryType))
            .bind(with: self) { owner, userLocationAndCategoryType in
                let (userLocation, categoryType) = userLocationAndCategoryType
                
                owner.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: userLocation.x, y: userLocation.y, page: 1, display: 30)
            }
            .disposed(by: disposeBag)
        
        searchLocationUseCase.storeVO
            .subscribe(onNext: { storeVO in
                if storeVO.stores.isEmpty {
                    output.storeEmptyViewHidden.accept(false)
                } else {
                    output.storeEmptyViewHidden.accept(true)
                }
                output.storeList.accept(storeVO.stores)
            }) { error in
                output.showErrorAlert.accept(error)
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
        
        searchLocationUseCase.updateStoreVO
            .withLatestFrom(input.willDisplayCell) { storeVO, willDisplayCell in
                return (storeVO, willDisplayCell)
            }
            .bind(with: self) { owner, visibleStore in
                let willDisplayStore = owner.storeList[visibleStore.1.row]
                
                if owner.shouldUpdateStore(store: visibleStore.0, visibleStore: willDisplayStore) {
                    owner.storeList[visibleStore.1.row] = visibleStore.0
                    output.storeList.accept(owner.storeList)
                }
            }
            .disposed(by: disposeBag)
        
        searchLocationUseCase.isLoding
            .bind(to: output.isLoding)
            .disposed(by: disposeBag)
        
        searchLocationUseCase.errorSubject
            .bind(to: output.showErrorAlert)
            .disposed(by: disposeBag)
    }
}

extension LocationViewModel {
    private func transformCollectionViewDataSource(input: LocationViewModel.Input, output: LocationViewModel.Output) {
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
