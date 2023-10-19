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

final class LocationViewModel: ViewModelType {
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
        let willDisplayCell: Observable<IndexPath>
        let didSelectMarker: PublishRelay<Int?>
        let didSelectCategoryCell: Observable<IndexPath>
        let changeMapLocation: PublishRelay<CLLocationCoordinate2D>
        let didSelectRefreshButton: Observable<Void>
        let didSelectUserLocationButton: Observable<Void>
        let didScrollStoreCollectionView: Observable<Int?>
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
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.locationUseCase.checkLocationAuthorization()
                owner.locationUseCase.checkAuthorization()
                owner.locationUseCase.observeUserLocation()
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppearEvent
            .withLatestFrom(input.willDisplayCell)
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.searchLocationUseCase.updateStoreCellObservable(index: indexPath.row, storeList: owner.storeList)
            })
            .disposed(by: disposeBag)
        
        let didSelectMarker = input.didSelectMarker
            .share()
        
        didSelectMarker
            .bind(to: output.selectedMarkerIndex)
            .disposed(by: disposeBag)
        
        didSelectMarker
            .withUnretained(self)
            .bind(onNext: { owner, index in
                guard let index = index else { return  }
                let store = owner.storeList[index]
                output.setCameraPosition.accept((store.y, store.x))
            })
            .disposed(by: disposeBag)
        
        input.didSelectCategoryCell
            .withLatestFrom(currentLocation) { index, location in
                return (index, location)
            }
            .withUnretained(self)
            .bind(onNext: { owner, indexLocation in
                let (indexPath, location) = indexLocation
                let categoryType = CategoryType.allCases[indexPath.row]
                
                output.reSearchButtonHidden.accept(true)
                owner.categoryType.accept(categoryType)
                owner.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: location.x, y: location.y, page: 1, display: 30)
            })
            .disposed(by: disposeBag)
        
        input.changeMapLocation
            .withUnretained(self)
            .bind(onNext: { owner, coordinate in
                output.reSearchButtonHidden.accept(false)
                owner.currentLocation.accept(coordinate)
            })
            .disposed(by: disposeBag)
        
        let currentLocationAndCategoryType = Observable.combineLatest(self.currentLocation, self.categoryType)
        
        input.didSelectRefreshButton
            .withLatestFrom(currentLocationAndCategoryType)
            .withUnretained(self)
            .flatMap { owner, currentLocationAndCategoryType -> Observable<String> in
                let (currentLocation, categoryType) = currentLocationAndCategoryType
                output.reSearchButtonHidden.accept(true)
                owner.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: currentLocation.x, y: currentLocation.y, page: 1, display: 30)
                
                let reverseGeocodeObservable = owner.locationUseCase.reverseGeocodeLocation(location: currentLocation.convertToCLLocation)
                    .catchAndReturn("알 수 없는 지역입니다.")
                
                return reverseGeocodeObservable
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
        
        input.didSelectUserLocationButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                output.reSearchButtonHidden.accept(true)
                owner.locationUseCase.startUpdatingLocation()
            })
            .disposed(by: disposeBag)
        
        input.didScrollStoreCollectionView
            .distinctUntilChanged()
            .withUnretained(self)
            .bind(onNext: { owner, percentVisible in
                guard let index = percentVisible else { return }
                let store = owner.storeList[index]
                output.setCameraPosition.accept((store.y, store.x))
                output.selectedMarkerIndex.accept(index)
            })
            .disposed(by: disposeBag)
        
        createOutput(input: input, output: output)
        transformCollectionViewDataSource(input: input, output: output)
        
        return output
    }
    
    private func createOutput(input: Input, output: Output) {
        let userLocationAndCategoryType = Observable.combineLatest(output.currentUserLocation, self.categoryType)
        
        self.locationUseCase.locationUpdateSubject
            .withLatestFrom(userLocationAndCategoryType)
            .withUnretained(self)
            .bind(onNext: { owner, userLocationAndCategoryType in
                let (userLocation, categoryType) = userLocationAndCategoryType
                
                owner.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: userLocation.x, y: userLocation.y, page: 1, display: 30)
            })
            .disposed(by: disposeBag)
        
        self.searchLocationUseCase.storeVO
            .subscribe(onNext: { storeVO in
                if storeVO.stores.isEmpty {
                    output.storeEmptyViewHidden.accept(false)
                } else {
                    output.storeEmptyViewHidden.accept(true)
                }
                output.storeList.accept(storeVO.stores)
            }) { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        let storeListObservable = output.storeList
        
        storeListObservable
            .withUnretained(self)
            .subscribe(onNext: { owner, storeVO in
                owner.storeList = storeVO
            })
            .disposed(by: disposeBag)
        
        let locationCoordinate = self.locationUseCase.locationCoordinate
            .share()
        
        locationCoordinate
            .withUnretained(self)
            .bind(onNext: { owner, coordinate in
                owner.currentLocation.accept(coordinate)
            })
            .disposed(by: disposeBag)
        
        locationCoordinate
            .bind(to: output.currentUserLocation)
            .disposed(by: disposeBag)
        
        locationCoordinate
            .withUnretained(self)
            .flatMapLatest { owner, location in
                let reverseGeocodeObservable = owner.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation)
                    .catchAndReturn("알 수 없는 지역입니다.")
                return reverseGeocodeObservable
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
        
        self.locationUseCase.authorizationDeniedStatus
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
        
        self.searchLocationUseCase.updateStoreVO
            .withLatestFrom(input.willDisplayCell) { storeVO, willDisplayCell in
                return (storeVO, willDisplayCell)
            }
            .withUnretained(self)
            .bind(onNext: { owner, visibleStore in
                let (storeVO, willDisplayCell) = visibleStore
                let visibleStore = owner.storeList[willDisplayCell.row]
                
                if owner.shouldUpdateStore(store: storeVO, visibleStore: visibleStore) {
                    owner.storeList[willDisplayCell.row] = storeVO
                    output.storeList.accept(owner.storeList)
                }
            })
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
