//
//  LocationDetailView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/03.
//

import UIKit

import NMapsMap

final class LocationDetailView: BaseView {

    lazy var detailMapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        mapView.zoomLevel = 15
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    
    
    var locationOverlay: NMFLocationOverlay?
    
    
    override func setHierarchy() {
        [detailMapView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
    }
}
