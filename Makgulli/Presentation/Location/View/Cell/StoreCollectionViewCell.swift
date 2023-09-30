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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellShadow(backView: containerView, radius: 23)
    }
    
    override func setHierarchy() {
        self.addSubview(containerView)
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
