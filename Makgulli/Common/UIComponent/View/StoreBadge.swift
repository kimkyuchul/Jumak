//
//  StoreBadge.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/08.
//

import UIKit

final class StoreBadge: BaseView {
        
    private let badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        return imageView
    }()
    private let badgeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._12)
        return label
    }()
    private lazy var badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(badgeImageView, badgeTitleLabel)
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fill
        return stackView
    }()
    
    convenience init(image: UIImage, text: String? = nil) {
        self.init()
        self.backgroundColor = .clear
        self.badgeImageView.image = image.withRenderingMode(.alwaysTemplate)
        self.badgeTitleLabel.text = text
    }
    
    override func setHierarchy() {
        self.addSubview(badgeStackView)
    }
    
    override func setConstraints() {
        badgeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension StoreBadge {
    func setSeletedBadgeColor(color: UIColor) {
        badgeImageView.tintColor = color
        badgeTitleLabel.textColor = color
    }
    
    func setBadgeTitle(text: String) {
        badgeTitleLabel.text = text
    }
}
