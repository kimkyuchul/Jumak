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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cellShadow(backView: containerView, radius: 23)
    }
    
    override func setHierarchy() {
        [containerView].forEach {
            self.addSubview($0)
        }
        containerView.addSubview(titleLabel)
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension EpisodeCollectionViewCell {
    func configureCell(item: EpisodeVO) {
        titleLabel.text = item.title
    }
}
