//
//  ImageSelectionView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

final class ImageSelectionView: BaseView {
    
    private let selectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.cameraIcon
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.darkGray
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카메라 텅텅 +"
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    
    override func setHierarchy() {
        [selectionImageView, titleLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        selectionImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(selectionImageView.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setLayout() {
        backgroundColor = .gray
        clipsToBounds = true
        layer.cornerRadius = 14
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
    }
}
