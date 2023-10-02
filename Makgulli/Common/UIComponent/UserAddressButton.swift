//
//  UserAddressButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/28.
//

import UIKit

import RxSwift
import RxCocoa

final class UserAddressButton: BaseView {
    
    fileprivate var addressButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.regularLineSeed(size: ._14)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.rightCircleArrowIcon
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.brown
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        self.dropShadow()
    }
    
    override func setHierarchy() {
        [addressButton, rightImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        
        addressButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            
        }
        
        rightImageView.snp.makeConstraints { make in
            make.leading.equalTo(addressButton.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
    }
}

extension Reactive where Base: UserAddressButton {
    var addressTitle: Binder<String?> {
        return base.addressButton.rx.title(for: .normal)
    }
}
