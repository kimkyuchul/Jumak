//
//  LocationViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit
import NMapsMap

import RxSwift
import RxCocoa

final class LocationViewController: BaseViewController {
    
    private let locationView = LocationView()
    
    private let viewModel = LocationViewModel(searchLocationUseCase: DefaultSearchLocationUseCase(searchLocationRepository: DefaultSearchLocationRepository(networkManager: NetworkManager())), locationUseCase: DefaultLocationUseCase(locationService: DefaultLocationManager()))
    private var markers: [NMFMarker] = []
    private var selectMarkerSubject = PublishSubject<Int>()
    
    override func loadView() {
        self.view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = LocationViewModel.Input(viewDidLoadEvent: Observable.just(()).asObservable())
        let output = viewModel.transform(input: input)
        
        output.locationVO
            .bind(onNext: { searchLocationVO in
                // 하단 콜렉션뷰 데이터 바인딩
            })
            .disposed(by: disposeBag)
        
        output.storeList
            .withUnretained(self)
            .bind(onNext: { owner, storeList in
                print(storeList)
                owner.setUpMarker(storeList: storeList)
            })
            .disposed(by: disposeBag)
            
        output.currentUserLocation
            .withUnretained(self)
            .bind(onNext: { owner, location in
                owner.updateUserCurrentLocation(latitude: location.latitude, longitude: location.longitude)
            })
            .disposed(by: disposeBag)
        
        output.authorizationAlertShouldShow
            .bind(onNext: { authorization in
                print(authorization)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUserCurrentLocation(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 15)
        locationView.mapView.moveCamera(cameraUpdate)
        cameraUpdate.animation = .easeIn
        
        guard let locationOverlay = locationView.locationOverlay else { return }
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
        locationOverlay.icon = NMFOverlayImage(name: "imgLocationDirection", in: Bundle.naverMapFramework())
    }
    
    private func setUpMarker(storeList: [DocumentVO]) {
        self.clearMarker()
        
        for (index, store) in storeList.enumerated() {
            let x = Double(store.x) ?? 0
            let y = Double(store.y) ?? 0
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: y, lng: x)
            marker.iconImage = NMFOverlayImage(name: "imgLocationDirection", in: Bundle.naverMapFramework())
            marker.mapView = self.locationView.mapView
            marker.touchHandler = { [weak self] _ in
                self?.selectMarkerSubject.onNext(index)
                return true
            }
            self.markers.append(marker)
        }
    }
    
    private func clearMarker() {
        for marker in self.markers {
            marker.mapView = nil
        }
        self.markers.removeAll()
    }
}
