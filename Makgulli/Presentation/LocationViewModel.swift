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
    
    init(searchLocationUseCase: SearchLocationUseCase, locationUseCase: LocationUseCase) {
        self.searchLocationUseCase = searchLocationUseCase
        self.locationUseCase = locationUseCase
    }
    
    deinit {
        print("Deinit LocationViewModel")
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let locationVO = PublishRelay<SearchLocationVO>()
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        let authorizationAlertShouldShow = BehaviorRelay<Bool>(value: false)
    }
    
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.locationUseCase.checkLocationAuthorization()
                owner.locationUseCase.checkAuthorization()
                owner.locationUseCase.observeUserLocation()
                owner.searchLocationUseCase.fetchLocation(query: "막걸리", x: "127.06283102249932", y: "37.514322572335935", page: 1, display: 30)
            })
            .disposed(by: disposeBag)
        
        
        let locationVO = searchLocationUseCase.locationVO
        
        locationVO
            .subscribe(onNext: { locationVO in
                output.locationVO.accept(locationVO)
            }) { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        self.locationUseCase.locationCoordinate
            .bind(to: output.currentUserLocation)
            .disposed(by: disposeBag)
        
        self.locationUseCase.authorizationDeniedStatus
            .bind(to: output.authorizationAlertShouldShow)
            .disposed(by: disposeBag)
                
        return output
    }
}
