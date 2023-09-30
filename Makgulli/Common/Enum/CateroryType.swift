//
//  CateroryType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

enum CategoryType: String, CaseIterable {
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
            return ImageLiteral.makgulliCategoryIcon
        case .pajeon:
            return ImageLiteral.pajeonCategoryIcon
        case .bossam:
            return ImageLiteral.bossamCategoryIcon
        }
    }
}
