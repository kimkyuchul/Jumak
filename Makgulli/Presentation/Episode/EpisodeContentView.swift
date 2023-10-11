//
//  EpisodeContentView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

import RxSwift
import RxCocoa

final class EpisodeContentView: BaseView {
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그날의 기억"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let commentTextField = EpisodeTextField(placeholderText: "그날의 한줄평을 기록해봐요.")
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    fileprivate let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brown
        return imageView
    }()
    
    fileprivate let tapGesture = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 14
        containerView.clipsToBounds = true
    }
    
    override func setHierarchy() {
        [episodeTitleLabel, commentTextField, containerView].forEach {
            addSubview($0)
        }
        
        [episodeImageView].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(120)
        }
        
        episodeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: EpisodeContentView {
    var imageViewTapGesture: ControlEvent<UITapGestureRecognizer> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        base.episodeImageView.addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer.rx.event
    }
}
