//
//  MapUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

protocol LocationUseCase {
    var locationCoordinate:  BehaviorRelay<CLLocationCoordinate2D> { get }
    var authorizationDeniedStatus: PublishRelay<Bool> { get }
    
    func observeUserLocation()
    func checkAuthorization()
    func checkLocationAuthorization()
}

final class DefaultLocationUseCase: LocationUseCase {
    
    private let locationService: LocationService
    private let disposebag = DisposeBag()
    
    // 권한 요청 거부 시 Default value 설정
    var locationCoordinate = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 127.06283102249932, longitude: 37.514322572335935))
    var authorizationDeniedStatus = PublishRelay<Bool>()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func observeUserLocation() {
        self.locationService.locationCoordinate
            .withUnretained(self)
            .bind(onNext: {owner, coordinate in
                owner.locationCoordinate.accept(coordinate)
            })
            .disposed(by: disposebag)
    }
    
    func checkAuthorization() {
        self.locationService.authorizationStatus
            .withUnretained(self)
            .bind(onNext: {owner, authorization in
                if authorization == .denied {
                    owner.authorizationDeniedStatus.accept(true)
                }
            })
            .disposed(by: disposebag)
    }
    
    func checkLocationAuthorization() {
        self.locationService.checkLocationAuthorization()
    }
}
