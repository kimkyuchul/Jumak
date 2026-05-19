//
//  AlcoholListCell.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

import KCImageCache
import KCImageCacheUI
import SnapKit

final class AlcoholListCell: BaseCollectionViewCell {

    private static let thumbnailPointSize = CGSize(width: 88, height: 88)

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let loadingIndicator = AlcoholThumbnailDecoration.makeLoadingIndicator()
    private let failureView = AlcoholThumbnailDecoration.makeFailureView()

    private let abvLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._12)
        label.textColor = .white
        return label
    }()

    private lazy var abvPillView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 11
        view.layer.masksToBounds = true
        view.addSubview(abvLabel)
        abvLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._18)
        label.textColor = .black
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let metaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._14)
        label.textColor = .mediumGray
        label.numberOfLines = 3
        return label
    }()

    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.18)
        return view
    }()

    override func setHierarchy() {
        [thumbnailImageView, nameLabel, abvPillView, metaLabel, instructionsLabel, dividerView].forEach {
            contentView.addSubview($0)
        }
    }

    override func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(88)
            make.bottom.lessThanOrEqualToSuperview().inset(14)
        }

        abvPillView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
            make.trailing.lessThanOrEqualTo(abvPillView.snp.leading).offset(-8)
        }

        metaLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(16)
        }

        instructionsLabel.snp.makeConstraints { make in
            make.top.equalTo(metaLabel.snp.bottom).offset(6)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(14)
        }

        dividerView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(14)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }

    override func setLayout() {
        backgroundColor = .white
        contentView.backgroundColor = .white
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.15,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState]
            ) {
                self.contentView.backgroundColor = self.isHighlighted ? .lightGray : .white
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.cancelKCImageLoad()
        thumbnailImageView.image = nil
        contentView.backgroundColor = .white
    }

    func configure(_ alcohol: AlcoholVO) {
        nameLabel.text = alcohol.name
        metaLabel.text = [alcohol.category, alcohol.glass]
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
        instructionsLabel.text = alcohol.instructions

        abvLabel.text = alcohol.alcoholic
        abvPillView.isHidden = alcohol.alcoholic.isEmpty

        let options = ImageRequestOptions(
            pointSize: Self.thumbnailPointSize,
            scale: traitCollection.displayScale
        )
        let request = URL(string: alcohol.thumbnailURL)
            .map { ImageRequest(url: $0, options: options) }

        thumbnailImageView.setKCImage(
            with: request,
            placeholder: loadingIndicator,
            failure: failureView
        )
    }
}
