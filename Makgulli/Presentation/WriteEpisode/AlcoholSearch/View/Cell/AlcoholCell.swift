//
//  AlcoholCell.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

import SnapKit

final class AlcoholCell: BaseCollectionViewCell {

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._12)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()

    private var imageLoadTask: URLSessionDataTask?

    override func setHierarchy() {
        [thumbnailImageView, nameLabel, categoryLabel].forEach {
            contentView.addSubview($0)
        }
    }

    override func setConstraints() {
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
            make.top.greaterThanOrEqualToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(thumbnailImageView.snp.centerY).offset(-2)
        }

        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(thumbnailImageView.snp.centerY).offset(2)
        }
    }

    override func setLayout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        thumbnailImageView.image = nil
        nameLabel.text = nil
        categoryLabel.text = nil
    }

    func configure(_ alcohol: AlcoholVO) {
        nameLabel.text = alcohol.name
        categoryLabel.text = alcohol.category
        loadThumbnail(from: alcohol.thumbnailURL)
    }

    private func loadThumbnail(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        }
        imageLoadTask = task
        task.resume()
    }
}
