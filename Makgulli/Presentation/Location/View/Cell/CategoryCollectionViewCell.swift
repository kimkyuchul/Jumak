//
//  CategoryCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

final class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            self.setSelected(isSelected: self.isSelected)
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .brown
        return imageView
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldLineSeed(size: ._12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellShadow(backView: containerView, radius: 23)
    }
    
    override func setHierarchy() {
        
        self.addSubview(containerView)
        
        [categoryImageView, categoryLabel].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        categoryImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryImageView.snp.trailing).offset(6)
            make.centerY.equalTo(categoryImageView.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setSelected(isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = UIColor.brown
            categoryLabel.textColor = .white
            categoryImageView.tintColor = .white
        } else {
            containerView.backgroundColor = .white
            categoryLabel.textColor = .darkGray
            categoryImageView.tintColor = .brown
        }
    }
}

extension CategoryCollectionViewCell {
    func configureCell(item: CategoryType) {
        categoryImageView.image = item.image.withRenderingMode(.alwaysTemplate)
        categoryLabel.text = item.title
    }
}
