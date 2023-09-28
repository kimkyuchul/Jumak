//
//  UIView+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

extension UIView {
    func dropShadow(color: UIColor = .black,
                    offset: CGSize = CGSize(width: 0, height: 8.0),
                    opacity: Float = 0.3,
                    radius: CGFloat = 10) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}


