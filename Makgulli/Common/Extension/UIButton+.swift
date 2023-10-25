//
//  UIButton+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}

extension UIButton.Configuration {
    mutating func setAttributedTitle(title: String, font: UIFont, color: UIColor) {
        let attributedTitle = NSAttributedString(string: title, attributes: [
            .font: font,
            .foregroundColor: color
        ])
        self.attributedTitle = AttributedString(attributedTitle)
    }
}
