//
//  LocationView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import UIKit

import RxSwift
import RxCocoa
import NMapsMap

class LocationView: BaseView {

    lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    let questionButton = QuestionButton()
    let userAddressButton = UserAddressButton()
    
    var locationOverlay: NMFLocationOverlay?
    
    override func setHierarchy() {
        [mapView, questionButton, userAddressButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        questionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(9)
        }
        
        userAddressButton.snp.makeConstraints { make in
            make.leading.equalTo(questionButton.snp.trailing).offset(11)
            make.centerY.equalTo(questionButton.snp.centerY)
            make.trailing.equalToSuperview().inset(24)
        }
    }
    
    fileprivate func moveCamera(latitude: Double, longitude: Double) {
            let cameraPosition = NMFCameraPosition(
                NMGLatLng(lat: latitude,lng: longitude),
                zoom: self.mapView.zoomLevel
            )
            let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
            
            cameraUpdate.animation = .easeIn
            self.mapView.moveCamera(cameraUpdate)
        }
}

extension Reactive where Base: LocationView {
    var cameraPosition: Binder<(Double, Double)> {
        return Binder(self.base) { view, cameraPosition in
            let (latitude, longitude) = cameraPosition
            view.moveCamera(latitude: latitude, longitude: longitude)
        }
    }
}
