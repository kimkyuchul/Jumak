//
//  LocationButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

final class LocationButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraints()
        
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.dropShadow()
    }
}

extension LocationButton {
    private func setLayout() {
        self.backgroundColor = UIColor.brown
        self.setImage(ImageLiteral.userLocationIcon, for: .normal)
        self.tintColor = UIColor.white
    }
    
    private func setConstraints() {
        self.snp.makeConstraints { make in
            make.size.equalTo(42)
        }
    }
}
