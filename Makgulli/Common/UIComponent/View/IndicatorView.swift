//
//  IndicatorView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/22.
//

import UIKit

import RxSwift

final class IndicatorView: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        center = self.center
        color = .brown
        hidesWhenStopped = true
        style = UIActivityIndicatorView.Style.large
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
 
