//
//  FavoriteEmptyView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/24.
//

import UIKit

final class FavoriteEmptyView: BaseView {
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.fillHeartIcon
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "막걸리 먹을 곳이 하나도 없네요."
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "막걸리찾기에서 나만의 막걸리 맛집을 찾아보세요."
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(emptyTitleLabel, emptySubLabel)
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 23
    }
    
    override func setHierarchy() {
        [emptyImageView, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.size.equalTo(60)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10).priority(.high)
        }
    }
    
    override func setLayout() {
        clipsToBounds = true
        backgroundColor = .white
    }
}
