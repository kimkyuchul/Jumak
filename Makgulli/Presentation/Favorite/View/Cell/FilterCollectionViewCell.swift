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
        label.font = UIFont.boldLineSeed(size: UIDevice.current.hasNotch ? ._16 : ._18)
        label.numberOfLines = 2
        label.sizeToFit()
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
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(storeTitleLabel, addressLabel)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        return stackView
    }()
    private let rateStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._14)
        return label
    }()
    private let rateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageLiteral.fillStarIcon
        return imageView
    }()
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._14)
        return label
    }()
    private lazy var rateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(rateImageView, rateLabel)
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fill
        return stackView
    }()
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = ImageLiteral.episodeDefaultImage
        return imageView
    }()
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    private lazy var episodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(episodeImageView, episodeLabel)
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fill
        stackView.backgroundColor = .blue
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 6, bottom: 5, trailing: 6)
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
        
        [logoImageView, titleStackView, rateStatusLabel, rateStackView, episodeStackView, bookmarkImageView, lineView].forEach {
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
            make.size.equalTo(UIDevice.current.hasNotch ? 105 : 115)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview()
        }
                
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.top)
            make.leading.equalTo(logoImageView.snp.trailing).offset(12)
            make.trailing.equalTo(bookmarkImageView.snp.leading).offset(4).priority(.high)
        }
        
        rateStatusLabel.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(10)
            make.leading.equalTo(storeTitleLabel.snp.leading)
        }
        
        rateImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
                
        rateStackView.snp.makeConstraints { make in
            make.leading.equalTo(rateStatusLabel.snp.trailing).offset(4)
            make.centerY.equalTo(rateStatusLabel.snp.centerY)
        }
        
        episodeImageView.snp.makeConstraints { make in
            make.size.equalTo(15)
        }
        
        episodeStackView.snp.makeConstraints { make in
            make.top.equalTo(rateStackView.snp.bottom).offset(4).priority(.high)
            make.leading.equalTo(titleStackView.snp.leading)
            make.bottom.equalTo(logoImageView.snp.bottom).priority(.low)
        }
                
        bookmarkImageView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setRateStatus(rate: Int) {
        if rate == 0 {
            rateStatusLabel.text = "평가하지 않음"
            rateStatusLabel.textColor = .deepDarkGray
            rateImageView.tintColor = .deepDarkGray
            rateLabel.textColor = .deepDarkGray
        } else {
            rateStatusLabel.text = "평가함"
            rateStatusLabel.textColor = .deepYellow
            rateImageView.tintColor = .deepYellow
            rateLabel.textColor = .deepYellow
        }
    }
}

extension FilterCollectionViewCell {
    func configureCell(item: StoreVO) {
        logoImageView.image = item.categoryType.logoImage.resize(newWidth: 50)
        storeTitleLabel.text = item.placeName
        addressLabel.text = item.addressName
        rateLabel.text = "\(item.rate)점"
        setRateStatus(rate: item.rate)
        episodeLabel.text = "\(item.episode.count)개 에피소드 존재"
        bookmarkImageView.tintColor = item.bookmark ? .pink : .gray
    }
}
