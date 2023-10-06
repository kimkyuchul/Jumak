//
//  RateButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

final class RateButton: UIButton {
    
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
        self.dropShadow()
    }
}

extension RateButton {
    private func setLayout() {
        self.setImage(ImageLiteral.starIcon, for: .normal)
        self.imageView?.contentMode = .scaleToFill
        self.tintColor = .yellow
        self.backgroundColor = .clear
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    private func setConstraints() {
        self.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
    }
}
