//
//  CheckBoxView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

import RxSwift
import RxCocoa

final class CheckBoxView: BaseView {

    let checkButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.black
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    private let checkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.regularLineSeed(size: ._14)
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }

    convenience init(checkLabelText: String) {
        self.init()
        self.checkLabel.text = checkLabelText
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }

    override func setHierarchy() {
        [checkButton, checkLabel].forEach {
            addSubview($0)
        }
    }

    override func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(25)
        }

        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func bind() {
        checkButton.rx.tap
            .withUnretained(self)
            .map { !$0.0.checkButton.isSelected }
            .bind(to: checkButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
}

