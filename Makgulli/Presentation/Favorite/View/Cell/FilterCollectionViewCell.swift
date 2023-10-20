//
//  FilterCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/20.
//

import UIKit

final class FilterCollectionViewCell: BaseCollectionViewCell {
        
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    private let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._18)
        label.numberOfLines = 2
        label.textColor = .black
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._12)
        label.numberOfLines = 1
        label.textColor = .darkGray
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
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImageView.layer.cornerRadius = 14
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
    
    override func setHierarchy() {
        self.addSubview(containerView)
        
        [logoImageView, storeTitleLabel, addressLabel, badgeStackView, bookmarkImageView, lineView].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
            make.size.equalTo(110)
        }
        
        storeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.top).offset(5)
            make.leading.equalTo(logoImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(15).priority(.high)
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
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
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

extension FilterCollectionViewCell {
    func configureCell(item: StoreVO) {
        logoImageView.image = item.categoryType.logoImage.resize(newWidth: 50)
        storeTitleLabel.text = item.placeName
        addressLabel.text = item.addressName
        rateBadge.setBadgeTitle(text: "\(item.rate)점")
        distanceBadge.setBadgeTitle(text: "\(item.distance)M")
        bookmarkImageView.tintColor = item.bookmark ? .pink : .gray
    }
}
