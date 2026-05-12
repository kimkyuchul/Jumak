//
//  Array+.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
