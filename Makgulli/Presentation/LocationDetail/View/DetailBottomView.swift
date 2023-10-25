//
//  DetailBottomView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailBottomView: BaseView {
    fileprivate let warningButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.warningIcon, for: .normal)
        button.tintColor = .darkGray
        button.backgroundColor = .pink
        return button
    }()
    fileprivate let makeEpisodeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.setTitle("에피소드 만들기", for: .normal)
        button.titleLabel?.font = UIFont.boldLineSeed(size: ._18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brown
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        warningButton.layer.cornerRadius = warningButton.frame.height / 2
    }
    
    override func setHierarchy() {
        [warningButton, makeEpisodeButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        warningButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(46)
        }
        
        makeEpisodeButton.snp.makeConstraints { make in
            make.centerY.equalTo(warningButton.snp.centerY)
            make.leading.equalTo(warningButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(46)
        }
        
        self.snp.makeConstraints { make in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let safeAreaInsetsBottom = (windowScene?.windows.first?.safeAreaInsets.bottom ?? 0) + 8
            make.top.equalTo(self.makeEpisodeButton).offset(8).priority(.high)
            make.bottom.equalTo(self.makeEpisodeButton).offset(safeAreaInsetsBottom).priority(.high)
        }
    }
}

extension Reactive where Base: DetailBottomView {
    var tapMakeEpisode: ControlEvent<Void> {
        return base.makeEpisodeButton.rx.tap
    }
    
    var tapWarning: ControlEvent<Void> {
        return base.warningButton.rx.tap
    }
}
