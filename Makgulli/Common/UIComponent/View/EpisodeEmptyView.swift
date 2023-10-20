//
//  EpisodeEmptyView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/19.
//

import UIKit

final class EpisodeEmptyView: BaseView {
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.episodeDefaultImage
            .withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.gray
        return imageView
    }()
    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 에피소드가 한개도 없네요."
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let emptySubLabel: UILabel = {
        let label = UILabel()
        label.text = "하단에 에피소드 추가하기를 통해 추억을 남기세요."
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldLineSeed(size: ._14)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 23
    }
        
    override func setHierarchy() {
        [emptyImageView, emptyTitleLabel, emptySubLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        emptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10).priority(.high)
        }
        
        emptySubLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10).priority(.high)
        }
    }
    
    override func setLayout() {
        clipsToBounds = true
        backgroundColor = .white
    }
}
