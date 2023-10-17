//
//  FilterHeaderView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/17.
//

import UIKit

import RxCocoa
import RxSwift

final class FilterHeaderView: UICollectionReusableView {
    
    fileprivate let storeCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let filterButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .small
        let attributedTitle = NSAttributedString(string: "최근에 담은 순",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._14),
                                                    .foregroundColor: UIColor.black
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.arrowDownIcon
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        let button = UIButton()
        button.configuration = configuration
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        [storeCountLabel, filterButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        storeCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalTo(storeCountLabel.snp.centerY)
        }
    }
}

extension FilterHeaderView {
    func configure(countTile: Int) {
        storeCountLabel.text = "총 \(countTile)개"
    }
}