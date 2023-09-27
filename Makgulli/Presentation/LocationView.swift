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
    
    var locationOverlay: NMFLocationOverlay?
    
    lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    
    
    override func setHierarchy() {
        self.addSubview(mapView)
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}
