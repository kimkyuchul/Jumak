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

class LocationViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    private let searchLocationUseCase: SearchLocationUseCase
    private let locationUseCase: LocationUseCase
    private var storeList: [DocumentVO] = []
    private var categoryType: CategoryType = .makgulli
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
        let didSelectMarker: PublishRelay<Int?>
        let didSelectCategoryCell: Observable<IndexPath>
        let changeMapLocation: PublishRelay<CLLocationCoordinate2D>
        let didSelectRefreshButton: Observable<Void>
    }
    
    struct Output {
        let storeList = PublishRelay<[DocumentVO]>()
        let selectedMarkerIndex = PublishRelay<Int?>()
        let setCameraPosition = PublishRelay<(Double, Double)>()
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        let currentUserAddress = PublishRelay<String>()
        let authorizationAlertShouldShow = BehaviorRelay<Bool>(value: false)
        let reSearchButtonHidden = PublishRelay<Bool>()
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
            .bind(onNext: { [weak self] indexLocation in
                let (indexPath, location) = indexLocation
                let categoryType = CategoryType.allCases[indexPath.row]
                
                output.reSearchButtonHidden.accept(true)
                self?.categoryType = categoryType
                self?.searchLocationUseCase.fetchLocation(query: categoryType.rawValue, x: location.x, y: location.y, page: 1, display: 30)
            })
            .disposed(by: disposeBag)
        
        input.changeMapLocation
            .withUnretained(self)
            .bind(onNext: { owner, coordinate in
                output.reSearchButtonHidden.accept(false)
                owner.currentLocation.accept(coordinate)
            })
            .disposed(by: disposeBag)
    
        input.didSelectRefreshButton
            .withLatestFrom(currentLocation)
            .flatMap { [weak self] location -> Observable<String> in
                output.reSearchButtonHidden.accept(false)
                self?.searchLocationUseCase.fetchLocation(query: self?.categoryType.rawValue ?? StringLiteral.MAKGULLI, x: location.x, y: location.y, page: 1, display: 30)
                return self?.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation) ?? .empty()
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
                        
        self.locationUseCase.locationUpdateSubject
            .withLatestFrom(output.currentUserLocation)
            .withUnretained(self)
            .bind(onNext: { owner, userLocation in
                owner.searchLocationUseCase.fetchLocation(query: "막걸리", x: userLocation.x, y: userLocation.y, page: 1, display: 30)
            })
            .disposed(by: disposeBag)
        
        self.searchLocationUseCase.locationVO
            .subscribe(onNext: { locationVO in
                output.storeList.accept(locationVO.documents)
            }) { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        let storeListObservable = output.storeList.asObservable()
        
        storeListObservable
            .withUnretained(self)
            .subscribe(onNext: { owner, documentVO in
                owner.storeList = documentVO
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
                return owner.locationUseCase.reverseGeocodeLocation(location: location.convertToCLLocation)
            }
            .bind(to: output.currentUserAddress)
            .disposed(by: disposeBag)
        
        self.locationUseCase.authorizationDeniedStatus
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
        
        return output
    }
}

