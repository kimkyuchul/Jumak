//
//  IndicatorView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/22.
//

import UIKit

import RxSwift

final class IndicatorView: UIActivityIndicatorView {
    init(style: UIActivityIndicatorView.Style = .large, size: CGFloat = 80) {
        super.init(style: style)
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        color = .brown
        hidesWhenStopped = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: UIActivityIndicatorView {
    var isAnimating: Binder<Bool> {
        return Binder(base) { activityIndicator, isAnimating in
            if isAnimating {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
            } else {
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
    }
}
 
