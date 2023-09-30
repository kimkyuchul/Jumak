//
//  CLLocationCoordinate2D+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/30.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var convertToCLLocation: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
    var x: String {
        return "\(self.longitude)"
    }
    
    var y: String {
        return "\(self.latitude)"
    }
}
