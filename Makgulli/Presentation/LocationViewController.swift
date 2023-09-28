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
    private var selectMarkerRelay = PublishRelay<Int?>()
    
    override func loadView() {
        self.view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = LocationViewModel.Input(viewDidLoadEvent: Observable.just(()).asObservable(), didSelectMarker: selectMarkerRelay)
        let output = viewModel.transform(input: input)
                
        output.storeList
            .take(1)
            .withUnretained(self)
            .bind(onNext: { owner, storeList in
                owner.setUpMarker(storeList: storeList)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.selectedMarkerIndex, output.storeList)
            .withUnretained(self)
            .bind(onNext: { owner, data in
                let (selectedIndex, storeList) = data
                guard selectedIndex ?? 0 < storeList.count else { return }
                owner.setUpMarker(selectedIndex: selectedIndex, storeList: storeList)
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
    
    private func setUpMarker(selectedIndex: Int? = nil, storeList: [DocumentVO]) {
        self.clearMarker()
        
        for (index, store) in storeList.enumerated() {
            let x = Double(store.x) ?? 0
            let y = Double(store.y) ?? 0
            
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: y, lng: x)
            
            if index == selectedIndex {
                marker.iconImage = NMFOverlayImage(image: ImageLiteral.touchMarker)
                marker.width = DesignLiteral.touchMarkerWidth
                marker.height = DesignLiteral.touchMarkerheight
            } else {
                marker.iconImage = NMFOverlayImage(image: ImageLiteral.marker)
                marker.width = DesignLiteral.marker
                marker.height = DesignLiteral.marker
            }
            
            marker.mapView = self.locationView.mapView
            marker.touchHandler = { [weak self] _ in
                self?.selectMarkerRelay.accept(index)
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
