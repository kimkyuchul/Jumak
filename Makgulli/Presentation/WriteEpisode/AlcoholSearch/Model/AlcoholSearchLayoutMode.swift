//
//  AlcoholSearchLayoutMode.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import Foundation

enum AlcoholSearchLayoutMode {
    case grid
    case list

    var toggled: AlcoholSearchLayoutMode {
        self == .grid ? .list : .grid
    }
}
