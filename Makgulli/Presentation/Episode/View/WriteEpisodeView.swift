//
//  WriteEpisodeView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import RxGesture

final class WriteEpisodeView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    fileprivate let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.xmarkIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .clear
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "에피소드 쓰기"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        return label
    }()
    fileprivate let placeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._18)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    fileprivate let writeButton = EpisodeButton(title: "에피소드 작성 완료")
    let episodeDateView = EpisodeDateView()
    let episodeContentView = EpisodeContentView()
    let episodeDrinkNameView = EpisodeDrinkNameView()
    let episodeDrinkCountView = EpisodeDrinkCountView()
    
    override func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [dismissButton, titleLabel, placeLabel, episodeDateView, episodeContentView, episodeDrinkNameView, episodeDrinkCountView, writeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.writeButton.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-keyboardVisibleHeight)
                }
                
                owner.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        contentView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(dismissButton.snp.centerY)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(10).priority(.high)
        }
        
        episodeDateView.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(10)
            make.leading.equalTo(placeLabel.snp.leading)
            make.trailing.equalToSuperview().inset(50)
        }
        
        episodeContentView.snp.makeConstraints { make in
            make.top.equalTo(episodeDateView.snp.bottom).offset(8)
            make.leading.equalTo(placeLabel.snp.leading)
            make.trailing.equalToSuperview().inset(18)
        }
        
        episodeDrinkNameView.snp.makeConstraints { make in
            make.top.equalTo(episodeContentView.snp.bottom).offset(8)
            make.leading.equalTo(placeLabel.snp.leading)
            make.trailing.equalTo(episodeContentView.snp.trailing)
        }
        
        episodeDrinkCountView.snp.makeConstraints { make in
            make.top.equalTo(episodeDrinkNameView.snp.bottom).offset(8)
            make.leading.equalTo(placeLabel.snp.leading)
            make.trailing.equalTo(episodeContentView.snp.trailing)
        }
        
        writeButton.snp.makeConstraints { make in
            make.top.equalTo(episodeDrinkCountView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(65)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func setLayout() {
        self.backgroundColor = .lightGray
    }
}

extension Reactive where Base: WriteEpisodeView {
    var tapDismiss: ControlEvent<Void> {
        return base.dismissButton.rx.tap
    }
    
    var tapWrite: ControlEvent<Void> {
        return base.writeButton.rx.tap
    }
    
    var placeTitle: Binder<String> {
        return Binder(self.base) { view, place in
            view.placeLabel.text = "\(place)에서\n도대체 무슨일이 있었던건가요?"
        }
    }
    
    var writeEnabled: Binder<Bool> {
        return base.writeButton.rx.isEnabled
    }
}
