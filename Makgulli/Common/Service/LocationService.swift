//
//  DefaultLocationService.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

protocol LocationService {
    var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get set }
    var locationCoordinate: PublishRelay<CLLocationCoordinate2D> { get set }
    var locationUpdateSubject: PublishSubject<Void> { get set }
    func start()
    func stop()
    func requestAuthorization()
    func checkLocationAuthorization()
}

// CLLocationManagerDelegate 사용 위해 NSObject 상속 필요
final class DefaultLocationManager: NSObject, LocationService {
    var locationManager: CLLocationManager?
    var locationCoordinate = PublishRelay<CLLocationCoordinate2D>()
    var locationUpdateSubject = PublishSubject<Void>()
    var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func requestAuthorization() {
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuthorization() {
        DispatchQueue.global().async {
            guard CLLocationManager.locationServicesEnabled() else {
                self.authorizationStatus.accept(.denied)
                return
            }
            
            DispatchQueue.main.async {
                switch self.locationManager?.authorizationStatus {
                case .notDetermined:
                    self.authorizationStatus.accept(.notDetermined)
                    self.requestAuthorization()
                case .restricted:
                    self.authorizationStatus.accept(.restricted)
                case .denied:
                    self.authorizationStatus.accept(.denied)
                case .authorizedWhenInUse, .authorizedAlways:
                    self.authorizationStatus.accept(.authorizedWhenInUse)
                    self.start()
                @unknown default:
                    break
                }
            }
        }
    }
}

extension DefaultLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            locationCoordinate.accept(coordinate)
            print("==", locationCoordinate.values)
            print("== \(#function)", coordinate)
        }
        
        locationUpdateSubject.onNext(())
        stop()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("==\(#function)", manager.authorizationStatus.rawValue)
        authorizationStatus.accept(manager.authorizationStatus)
        checkLocationAuthorization()
    }
}
