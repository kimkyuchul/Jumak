//
//  EpisodeCollectionViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

final class EpisodeCollectionViewCell: BaseCollectionViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 상세 정보"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._20)
        return label
    }()
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellShadow(backView: containerView, radius: 23)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeImageView.image = nil
    }
    
    override func setHierarchy() {
        contentView.addSubview(containerView)
        
        [titleLabel, episodeImageView].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        episodeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
}

extension EpisodeCollectionViewCell {
    func configureCell(item: Episode) {
        titleLabel.text = item.id
        
        if !item.imageData.isEmpty {
            episodeImageView.image = UIImage(data: item.imageData)
        } else {
            episodeImageView.image = ImageLiteral.episodeDefaultImage
        }
    }
}
