//
//  StoreCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/01.
//

import UIKit

final class StoreCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .pink
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
}

extension StoreCollectionViewCell {
    func configureCell(item: DocumentVO) {
        storeTitleLabel.text = item.placeName
    }
}
