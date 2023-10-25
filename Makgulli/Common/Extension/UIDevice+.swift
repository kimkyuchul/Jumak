//
//  UIDevice+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let bottom = scenes?.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
