//
//  UIButton+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

extension UIButton.Configuration {
    mutating func setAttributedTitle(title: String, font: UIFont, color: UIColor) {
        let attributedTitle = NSAttributedString(string: title, attributes: [
            .font: font,
            .foregroundColor: color
        ])
        self.attributedTitle = AttributedString(attributedTitle)
    }
}
