//
//  StoreEmptyView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/03.
//

import UIKit

final class StoreEmptyView: BaseView {
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.storeEmptyIcon
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주변에 막걸리가 없네요."
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 지역에서 검색해보세요."
        label.textColor = .gray
        label.font = UIFont.boldLineSeed(size: ._12)
        return label
    }()
    
    override func setHierarchy() {
        [emptyImageView, emptyTitleLabel, emptySubLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(130)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
            
        }
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.top)
            make.leading.equalTo(emptyImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().priority(.high)
        }
        
        emptySubLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(emptyTitleLabel.snp.leading)
            make.trailing.equalTo(emptyTitleLabel.snp.trailing)
        }
    }
    
    override func setLayout() {
        super.setLayout()
    }
}


