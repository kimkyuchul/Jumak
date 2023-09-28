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
    var locationCoordinate:  BehaviorRelay<CLLocationCoordinate2D> { get set }
    var authorizationDeniedStatus: PublishRelay<Bool> { get set  }
    var locationUpdateSubject: PublishRelay<Void> { get set }
    
    func observeUserLocation()
    func checkAuthorization()
    func checkLocationAuthorization()
    func reverseGeocodeLocation(location: CLLocation) -> Observable<String>
}

final class DefaultLocationUseCase: LocationUseCase {
    
    private let locationService: LocationService
    private let disposebag = DisposeBag()
    
    // 권한 요청 거부 시 Default value 설정
    var locationCoordinate = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: 127.06283102249932, longitude: 37.514322572335935))
    var authorizationDeniedStatus = PublishRelay<Bool>()
    var locationUpdateSubject = PublishRelay<Void>()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func observeUserLocation() {
        self.locationService.locationCoordinate
            .withUnretained(self)
            .bind(onNext: {owner, coordinate in
                owner.locationCoordinate.accept(coordinate)
                owner.locationUpdateSubject.accept(())
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
    
    func reverseGeocodeLocation(location: CLLocation) -> Observable<String> {
        let geocoder = CLGeocoder()
        return Observable.create { emitter in
             geocoder.reverseGeocodeLocation(location) { placemarks, error in
                 if let error = error {
                     emitter.onError(error)
                     return
                 }
                 
                 guard let placemark = placemarks?.first else {
                     emitter.onError(error!)
                     return
                 }
                 
                 let formattedAddress = self.getAddressString(from: placemark)
                 emitter.onNext(formattedAddress)
                 emitter.onCompleted()
             }
             return Disposables.create()
         }
     }
}

private extension DefaultLocationUseCase {
    func getAddressString(from placemark: CLPlacemark) -> String {
        var addressString = ""
        
        if let locality = placemark.locality {
            addressString += locality + " "
        }
        
//        if let subLocality = placemark.subLocality {
//            addressString += subLocality + " "
//        }
        
        if let thoroughfare = placemark.thoroughfare {
            addressString += thoroughfare + " "
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            addressString += subThoroughfare
        }
        
        if let postalCode = placemark.postalCode {
            addressString += ", " + postalCode
        }
        
        return addressString
    }
}
