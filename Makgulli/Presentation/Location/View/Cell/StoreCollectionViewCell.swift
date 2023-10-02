//
//  StoreCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/01.
//

import UIKit

final class StoreCollectionViewCell: BaseCollectionViewCell {
    
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
    
    private let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldLineSeed(size: ._12)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellShadow(backView: containerView, radius: 23)
    }
    
    override func setHierarchy() {
        self.addSubview(containerView)
        
        [storeTitleLabel].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        storeTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setSelected(isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = UIColor.brown
            storeTitleLabel.textColor = .white
        } else {
            containerView.backgroundColor = .white
            storeTitleLabel.textColor = .black
        }
    }
}

extension StoreCollectionViewCell {
    func configureCell(item: DocumentVO) {
        storeTitleLabel.text = item.placeName
    }
}
