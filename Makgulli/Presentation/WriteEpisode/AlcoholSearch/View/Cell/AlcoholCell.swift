//
//  AlcoholCell.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

import KCImageCache
import KCImageCacheUI
import SnapKit

final class AlcoholCell: BaseCollectionViewCell {

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    private let abvLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._12)
        label.textColor = .white
        return label
    }()

    private lazy var abvPillView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.addSubview(abvLabel)
        abvLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._18)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    private let loadingIndicator = AlcoholThumbnailDecoration.makeLoadingIndicator()
    private let failureView = AlcoholThumbnailDecoration.makeFailureView()

    override func setHierarchy() {
        [thumbnailImageView, abvPillView, nameLabel, subtitleLabel].forEach {
            contentView.addSubview($0)
        }
    }

    override func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(5.0 / 4.0).priority(999)
        }

        abvPillView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView).inset(12)
            make.trailing.equalTo(thumbnailImageView).inset(12)
            make.height.equalTo(24)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(2)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(2)
            make.bottom.lessThanOrEqualToSuperview().inset(4)
        }
    }

    override func setLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: 0.18,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState]
            ) {
                self.contentView.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.96, y: 0.96)
                    : .identity
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.cancelKCImageLoad()
        thumbnailImageView.image = nil
        contentView.transform = .identity
    }

    func configure(_ alcohol: AlcoholVO, thumbnailSize: CGSize) {
        nameLabel.text = alcohol.name
        subtitleLabel.text = [alcohol.category, alcohol.glass]
            .filter { !$0.isEmpty }
            .joined(separator: " · ")

        abvLabel.text = alcohol.alcoholic
        abvPillView.isHidden = alcohol.alcoholic.isEmpty

        let options = ImageRequestOptions(
            pointSize: thumbnailSize,
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
