//
//  WriteEpisodeView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import UIKit

import RxSwift
import RxCocoa

final class WriteEpisodeView: BaseView {
    
    fileprivate let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.xmarkIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .clear
        return button
    }()
    fileprivate let writeButton = EpisodeButton(title: "에피소드 작성 완료")
    
    
    override func setHierarchy() {
        [dismissButton, writeButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(18)
            make.leading.equalToSuperview().inset(14)
            make.size.equalTo(40)
        }
        
        writeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}

extension Reactive where Base: WriteEpisodeView {
    var tapDismiss: ControlEvent<Void> {
        return base.dismissButton.rx.tap
    }
    
    var tapWrite: ControlEvent<Void> {
        return base.writeButton.rx.tap
    }
}
