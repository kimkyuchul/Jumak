//
//  EpisodeDrinkCountView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/12.
//

import UIKit

import RxSwift
import RxCocoa

final class EpisodeDrinkCountView: BaseView {
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "얼마나 많이 마셨어요?"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let countContainerView = UIView()
    fileprivate let drinkCountTextField: EpisodeTextField = {
        let episodeTextField = EpisodeTextField(height: 40)
        episodeTextField.textAlignment = .center
        episodeTextField.isUserInteractionEnabled = false
        return episodeTextField
    }()
    fileprivate let minusCountButton = DefaultCircleButton(image: ImageLiteral.minusIcon, tintColor: .black, backgroundColor: .gray)
    fileprivate let plusCountButton = DefaultCircleButton(image: ImageLiteral.plusIcon, tintColor: .black, backgroundColor: .darkGray)
    private let selectQuantityButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .small
        let attributedTitle = NSAttributedString(string: "병",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._14),
                                                    .foregroundColor: UIColor.black
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.arrowDownIcon
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 50
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
        configuration.imagePlacement = .trailing
        let button = UIButton()
        button.configuration = configuration
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(countContainerView, selectQuantityButton)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()
    
    let quantitySubject = PublishSubject<QuantityType>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setQuantityUImenu()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectQuantityButton.layer.cornerRadius = 14
    }
    
    override func setHierarchy() {
        [drinkCountTextField, minusCountButton, plusCountButton].forEach {
            countContainerView.addSubview($0)
        }
        
        [episodeTitleLabel, stackView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        drinkCountTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        minusCountButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(34)
        }
        plusCountButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(34)
        }
        
        selectQuantityButton.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.35)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        countContainerView.clipsToBounds = true
    }
}

extension EpisodeDrinkCountView {
    private func setQuantityUImenu() {
        let quantityTypes: [QuantityType] = [.glass, .bottle, .packet]
        
        selectQuantityButton.menu = UIMenu(
            title: "단위",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: quantityTypes.map { quantityType in
                UIAction(title: quantityType.rawValue, image: nil) { [weak self] _ in
                    self?.quantitySubject.onNext(quantityType)
                    guard let attributedTitle = self?.setNSAttributedString(quantityType.rawValue) else { return }
                    self?.selectQuantityButton.configuration?.attributedTitle = AttributedString(attributedTitle)
                }
            }
        )
    }
    
    private func setNSAttributedString(_ title: String) -> NSAttributedString {
        return NSAttributedString(string: title,
                                  attributes: [
                                    .font: UIFont.boldLineSeed(size: ._14),
                                    .foregroundColor: UIColor.black
                                  ])
    }
}

extension Reactive where Base: EpisodeDrinkCountView {
    var tapMinus: ControlEvent<Void> {
        return base.minusCountButton.rx.tap
    }
    
    var tapPlus: ControlEvent<Void> {
        return base.plusCountButton.rx.tap
    }
    
    var drinkCount: Binder<Double> {
        return Binder(self.base) { (view, drinkCount) in
            view.drinkCountTextField.text = "\(drinkCount)"
        }
    }
}
