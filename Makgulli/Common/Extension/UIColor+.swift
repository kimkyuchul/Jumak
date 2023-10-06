//
//  UIColor+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit

extension UIColor {
    static var gray: UIColor {
        return UIColor(hex: "#D2D4D7")
    }
    
    static var deeplightGray: UIColor {
        return UIColor(hex: "#F5F5F5")
    }
    
    static var lightGray: UIColor {
        return UIColor(hex: "#ECECEC")
    }
    
    static var mediumGray: UIColor {
        return UIColor(hex: "#5C5C5C")
    }
    
    static var darkGray: UIColor {
        return UIColor(hex: "#8F9194")
    }
    
    static var deepDarkGray: UIColor {
        return UIColor(hex: "#515151")
    }
    
    static var black: UIColor {
        return UIColor(hex: "#000000")
    }
    
    static var white: UIColor {
        return UIColor(hex: "#F5F5F5")
    }
        
    static var blue: UIColor {
        return UIColor(hex: "#5CABF4")
    }
    
    static var red: UIColor {
        return UIColor(hex: "#C34F4F")
    }
    
    static var brown: UIColor {
        return UIColor(hex: "#A46C54")
    }
    
    static var pink: UIColor {
        return UIColor(hex: "#FFA9C8")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
