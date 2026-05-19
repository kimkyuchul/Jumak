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
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        config.image = UIImage(systemName: "magnifyingglass", withConfiguration: symbolConfig)
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.baseBackgroundColor = .brown
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 14)
        var titleAttr = AttributeContainer()
        titleAttr.font = UIFont.boldLineSeed(size: ._14)
        titleAttr.foregroundColor = .white
        config.attributedTitle = AttributedString("검색", attributes: titleAttr)
        button.configuration = config
        button.layer.shadowColor = UIColor.brown.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 6
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.accessibilityLabel = "술 검색"
        button.accessibilityHint = "탭하면 술 목록에서 검색해요."
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
            make.height.equalTo(32)
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

    var drinkNameText: Binder<String> {
        return Binder(self.base) { view, name in
            view.drinkNameTextField.text = name
        }
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
