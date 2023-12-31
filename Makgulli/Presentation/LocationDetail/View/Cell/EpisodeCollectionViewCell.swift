//
//  EpisodeCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

final class EpisodeCollectionViewCell: BaseCollectionViewCell {
    
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode"
        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    private let episodeBadge: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.episodeDefaultImage
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .pink
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 23
        episodeImageView.layer.cornerRadius = 23
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeImageView.image = nil
    }
    
    override func setHierarchy() {
        [episodeImageView, titleLabel, dateLabel, episodeBadge].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        episodeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().inset(14)
            make.size.equalTo(self.snp.width).multipliedBy(0.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(episodeImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        episodeBadge.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(15)
            make.size.equalTo(40)
        }
    }
    
    override func setLayout() {
        clipsToBounds = true
        backgroundColor = .white
    }
}

extension EpisodeCollectionViewCell {
    func configureCell(item: Episode, episodeIndex: Int) {
        if !item.imageData.isEmpty {
            episodeImageView.image = UIImage(data: item.imageData)
        } else {
            episodeImageView.image = ImageLiteral.episodeDefaultImage
        }
        
        titleLabel.text = "\(episodeIndex)번째\nLegendary\nEpisode"
        dateLabel.text = item.date.formattedDate()
    }
}
