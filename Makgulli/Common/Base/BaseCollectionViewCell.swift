//
//  BaseCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, ViewSetupable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
        setLayout()
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() { }
    func setConstraints() { }
    func setLayout() {
        self.backgroundColor = .clear
    }
}
