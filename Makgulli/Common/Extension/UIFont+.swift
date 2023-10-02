//
//  UIFont+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit

extension UIFont {
    enum Family: String {
        case bold = "Bold"
        case regular = "Regular"
        case thin = "Thin"
    }
    
    enum Size: CGFloat {
        case _10 = 10
        case _12 = 12
        case _14 = 14
        case _16 = 16
        case _20 = 20
    }
    
    static func boldLineSeed(size: Size, family: Family = .bold) -> UIFont {
        return UIFont(name: "LINESeedSansKR-\(family)", size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
    static func regularLineSeed(size: Size, family: Family = .regular) -> UIFont {
        return UIFont(name: "LINESeedSansKR-\(family)", size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
    
    static func thinLineSeed(size: Size, family: Family = .thin) -> UIFont {
        return UIFont(name: "LINESeedSansKR-\(family)", size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
    }
}


