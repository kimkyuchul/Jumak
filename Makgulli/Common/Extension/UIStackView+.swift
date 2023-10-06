//
//  UIStackView+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/06.
//

import UIKit

extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}
