//
//  EpisodeContentView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture

final class EpisodeContentView: BaseView {
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그날의 기억"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    fileprivate let commentTextField = EpisodeTextField(placeholderText: "그날의 한줄평을 기록해봐요.")
    private let imageSelectionView = ImageSelectionView()
    fileprivate let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setHierarchy() {
        [episodeTitleLabel, commentTextField, imageSelectionView].forEach {
            addSubview($0)
        }
        
        [episodeImageView].forEach {
            imageSelectionView.addSubview($0)
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
        
        imageSelectionView.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(140)
        }
        
        episodeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension Reactive where Base: EpisodeContentView {
    var imageViewTapGesture: Signal<Void> {
        return base.episodeImageView.rx.tapGesture().when(.recognized).map { _ in }.asSignal(onErrorJustReturn: ())
    }
    
    var comment: Observable<String> {
        return base.commentTextField.rx.text.orEmpty.asObservable()
    }
    
    var image: Binder<UIImage?> {
        return base.episodeImageView.rx.image
    }
    
    var hasImage: Observable<Bool> {
        return base.episodeImageView.rx.observe(UIImage.self, "image")
            .map { $0 != nil }
            .distinctUntilChanged()
    }
}
