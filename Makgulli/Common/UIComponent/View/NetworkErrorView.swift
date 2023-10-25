//
//  NetworkErrorView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

final class NetworkErrorView: BaseView {
    
    private let networkErrorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.networkErrorIcon
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    private let networkErrorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워크 에러가 발생했어요."
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    private let networkErrorSubLabel: UILabel = {
        let label = UILabel()
        label.text = "네트워크 연결을 다시 확인 후 이용해주세요."
        label.textColor = .gray
        label.font = UIFont.boldLineSeed(size: ._12)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 23
        dropShadow()
    }
        
    override func setHierarchy() {
        [networkErrorImageView, networkErrorTitleLabel, networkErrorSubLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        networkErrorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
        networkErrorTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(networkErrorImageView.snp.top)
            make.leading.equalTo(networkErrorImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().priority(.high)
        }
        
        networkErrorSubLabel.snp.makeConstraints { make in
            make.top.equalTo(networkErrorTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(networkErrorTitleLabel.snp.leading)
            make.trailing.equalTo(networkErrorTitleLabel.snp.trailing)
        }
    }
    
    override func setLayout() {
        backgroundColor = .white
    }
}

