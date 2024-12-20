//
//  EpisodeDetailView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/16.
//

import UIKit

import RxSwift
import RxCocoa

final class EpisodeDetailView: BaseView {
    
    fileprivate lazy var navigationBar: JumakNavigationBar = {
        let navigationBar = JumakNavigationBar(rightItems: [deleteBarButton])
        navigationBar.backgroundColor = .lightGray
        return navigationBar
    }()
    fileprivate let deleteBarButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.deleteEpisodeIcon, for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "에피소드"
        label.font = UIFont.boldLineSeed(size: ._18)
        label.textColor = .deepDarkGray
        return label
    }()
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._20)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    fileprivate let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    private let commentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그날의 한줄평"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        return label
    }()
    fileprivate let commentTextField: EpisodeTextField = {
        let episodeTextField = EpisodeTextField()
        episodeTextField.font = UIFont.regularLineSeed(size: ._16)
        episodeTextField.isUserInteractionEnabled = false
        return episodeTextField
    }()
    private let drinkNmaeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그날 먹은 술"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        return label
    }()
    fileprivate let drinkNameTextField: EpisodeTextField = {
        let episodeTextField = EpisodeTextField(height: 40)
        episodeTextField.isUserInteractionEnabled = false
        return episodeTextField
    }()
    private let drinkCountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "그날 먹은 음주량"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        return label
    }()
    fileprivate let drinkCountTextField: EpisodeTextField = {
        let episodeTextField = EpisodeTextField(height: 40)
        episodeTextField.isUserInteractionEnabled = false
        return episodeTextField
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        episodeImageView.layer.cornerRadius = 14
    }
    
    override func setHierarchy() {
        [navigationBar, titleLabel, dateLabel, episodeImageView, commentTitleLabel, commentTextField, drinkNmaeTitleLabel, drinkNameTextField, drinkCountTitleLabel, drinkCountTextField].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24).priority(.high)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing).priority(.high)
        }
        
        episodeImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        commentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeImageView.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        
        drinkNmaeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        
        drinkNameTextField.snp.makeConstraints { make in
            make.top.equalTo(drinkNmaeTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        
        drinkCountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(drinkNameTextField.snp.bottom).offset(15)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        
        drinkCountTextField.snp.makeConstraints { make in
            make.top.equalTo(drinkCountTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.bottom.equalToSuperview().inset(30).priority(.low)
        }
    }
    
    override func setLayout() {
        self.backgroundColor = .lightGray
    }
}

extension Reactive where Base: EpisodeDetailView {
    var backButtonTap: Observable<Void> {
        return self.base.navigationBar.backButtonAction()
    }
    
    var deleteButtonTap: Observable<Void> {
        return self.base.deleteBarButton.rx.tap.asObservable()
    }
    
    var episode: Binder<Episode> {
        return Binder(self.base) { view, episode in
            view.dateLabel.text = episode.date.formattedDate()
            
            if let originalImage = UIImage(data: episode.imageData), let compressedImageData = originalImage.jpegData(compressionQuality: 1.0) {
                view.episodeImageView.image = UIImage(data: compressedImageData)
            }
            
            view.commentTextField.text = episode.comment
            view.drinkNameTextField.text = episode.alcohol
            view.drinkCountTextField.text = "\(episode.drink) \(episode.drinkQuantity.rawValue)"
        }
    }
}




