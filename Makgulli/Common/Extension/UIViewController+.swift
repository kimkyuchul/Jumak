//
//  UIViewController+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/09.
//

import UIKit

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = BasePaddingLabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.textColor = .white
        toastLabel.font = .boldLineSeed(size: ._14)
        toastLabel.backgroundColor = .black
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        view.addSubview(toastLabel)
        
        toastLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalToSuperview().inset(100)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
