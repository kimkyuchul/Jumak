//
//  QuantityType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/12.
//

import UIKit

import RealmSwift


enum QuantityType: String, CaseIterable, PersistableEnum {
    case glass = "잔"
    case bottle = "병"
    case packet = "짝"
}
