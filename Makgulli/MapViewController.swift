//
//  MapViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit
import NMapsMap

final class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}
