//
//  CategoryType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

import RealmSwift

enum CategoryType: String, CaseIterable, PersistableEnum {
    case makgulli = "막걸리"
    case pajeon = "파전"
    case bossam = "보쌈"
    
    var title: String {
        switch self {
        case .makgulli:
            return StringLiteral.MAKGULLI
        case .pajeon:
            return StringLiteral.PAJEON
        case .bossam:
            return StringLiteral.BOSSAM
        }
    }
    
    var image: UIImage {
        switch self {
        case .makgulli:
            return ImageLiteral.boltHeartFillIcon
        case .pajeon:
            return ImageLiteral.pajeonCategoryIcon
        case .bossam:
            return ImageLiteral.bossamCategoryIcon
        }
    }
    
    var logoImage: UIImage {
        switch self {
        case .makgulli:
            return ImageLiteral.makgulliLogo
        case .pajeon:
            return ImageLiteral.pajeonLogo
        case .bossam:
            return ImageLiteral.bossamLogo
        }
    }
    
    var hashTag: String {
        switch self {
        case .makgulli:
            return "#막걸리"
        case .pajeon:
            return "#파전"
        case .bossam:
            return "#보쌈"
        }
    }
}
