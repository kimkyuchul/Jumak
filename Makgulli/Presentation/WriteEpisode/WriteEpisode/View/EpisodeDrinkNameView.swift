//
//  EpisodeDrinkNameView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

import RxSwift
import RxCocoa

final class EpisodeDrinkNameView: BaseView {
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 종류의 술을 먹었나요?"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    fileprivate let drinkSearchButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config) ?? UIImage()
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.accessibilityLabel = "술 검색"
        return button
    }()
    fileprivate let drinkNameTextField = EpisodeTextField(placeholderText: "먹은 술 이름을 기억해보세요.")
    fileprivate let checkBoxButton = CheckBoxView(checkLabelText: "술이 기억이 안나요.")
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(drinkNameTextField, checkBoxButton)
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    override func setHierarchy() {
        [episodeTitleLabel, drinkSearchButton, stackView].forEach {
            addSubview($0)
        }
    }

    override func setConstraints() {
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        drinkSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(episodeTitleLabel.snp.centerY)
            make.leading.greaterThanOrEqualTo(episodeTitleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension Reactive where Base: EpisodeDrinkNameView {
    var drinkSearchButtonTap: Observable<Void> {
        return base.drinkSearchButton.rx.tap.asObservable()
    }

    var tapCheckButton: Observable<Bool> {
        return base.checkBoxButton.checkButton.rx.isSelected.asObservable()
    }
    
    var drinkName: Observable<String> {
        return base.drinkNameTextField.rx.text.orEmpty.asObservable()
    }
    
    var drinkNameEditingDidBegin: ControlEvent<Void> {
        return base.drinkNameTextField.rx.controlEvent(.editingDidBegin)
    }
    
    var drinkNameEditingDidEnd: ControlEvent<Void> {
        return base.drinkNameTextField.rx.controlEvent(.editingDidEnd)
    }
    
    var isForgetDrinkName: Binder<Bool> {
        return Binder(self.base) { (view, isForgetDrinkName) in
            if isForgetDrinkName {
                view.checkBoxButton.checkButton.setImage(ImageLiteral.checkIcon, for: .normal)
                view.drinkNameTextField.isEnabled = false
                view.drinkNameTextField.backgroundColor = .lightGray
            } else {
                view.checkBoxButton.checkButton.setImage(nil, for: .normal)
                view.drinkNameTextField.isEnabled = true
                view.drinkNameTextField.backgroundColor = .white
            }
        }
    }
}
