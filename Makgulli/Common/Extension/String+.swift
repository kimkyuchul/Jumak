//
//  String+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

extension String {
    func convertMetersToKilometers() -> Double? {
        if let meters = Double(self) {
            let kilometers = meters / 1000.0
            return (kilometers * 10).rounded() / 10 
        }
        return nil
    }
}
