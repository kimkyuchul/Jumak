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
    private let logoImageView = UIImageView()
    private let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._18)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    private let rateBadge = StoreBadge(image: ImageLiteral.starCircleIcon)
    private let distanceBadge = StoreBadge(image: ImageLiteral.storeLocationIcon)
    private lazy var badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(rateBadge, distanceBadge)
        stackView.axis = .horizontal
        stackView.spacing = 14
        stackView.distribution = .fill
        return stackView
    }()
    private let bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.circleHeart
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .gray
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellShadow(backView: containerView, radius: 23)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
    
    override func setHierarchy() {
        self.addSubview(containerView)
        
        [logoImageView, storeTitleLabel, addressLabel, badgeStackView, bookmarkImageView].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(14)
            make.size.equalTo(80)
        }
        
        storeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.top).offset(6)
            make.leading.equalTo(logoImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(10).priority(.high)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(storeTitleLabel.snp.bottom).offset(2).priority(.high)
            make.leading.equalTo(storeTitleLabel.snp.leading)
            make.trailing.equalTo(storeTitleLabel.snp.trailing)
        }
        
        badgeStackView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(5).priority(.low)
            make.leading.equalTo(storeTitleLabel.snp.leading)
            make.bottom.equalToSuperview().inset(18)
        }
        
        bookmarkImageView.snp.makeConstraints { make in
            make.size.equalTo(38)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(badgeStackView.snp.bottom).offset(2)
        }
    }
    
    private func setSelected(isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = UIColor.brown
            storeTitleLabel.textColor = .white
            addressLabel.textColor = .pink
            rateBadge.setSeletedBadgeColor(color: .white)
            distanceBadge.setSeletedBadgeColor(color: .white)
        } else {
            containerView.backgroundColor = .white
            storeTitleLabel.textColor = .black
            addressLabel.textColor = .darkGray
            rateBadge.setSeletedBadgeColor(color: .black)
            distanceBadge.setSeletedBadgeColor(color: .black)
        }
    }
}

extension StoreCollectionViewCell {
    func configureCell(item: StoreVO) {
        logoImageView.image = item.categoryType.logoImage.resize(newWidth: 50)
        storeTitleLabel.text = item.placeName
        addressLabel.text = item.addressName
        rateBadge.setBadgeTitle(text: "\(item.rate)점")
        distanceBadge.setBadgeTitle(text: "\(item.distance)M")
        bookmarkImageView.tintColor = item.bookmark ? .pink : .gray
    }
}
