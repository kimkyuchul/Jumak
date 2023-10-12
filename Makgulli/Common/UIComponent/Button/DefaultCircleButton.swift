//
//  DefaultCircleButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

final class DefaultCircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dropShadow()
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, tintColor: UIColor, backgroundColor: UIColor) {
        self.init()
        self.setImage(image, for: .normal)
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
