//
//  DetailRateView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailRateView: BaseView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 23
        return view
    }()
    private let rateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "막걸리 맛이 어떠셨나요 :)"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._20)
        return label
    }()
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        return view
    }()
    
    private var starNumber: Int = 5 {
        didSet { bind() }
    }
    var currentStar: Int = 0 {
        didSet {
            updateStars()
            currentStarSubject.onNext(currentStar)
        }
    }
    var currentStarSubject = PublishSubject<Int>()
    private var buttons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.backgroundColor = .white
        bind()
    }
    
    private func bind() {
        for index in 0..<5 {
            let button = RateButton()
            button.tag = index
            buttons += [button]
            stackView.addArrangedSubview(button)
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.buttonTapped(tag: index)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func buttonTapped(tag: Int) {
        if tag == currentStar - 1 {
            for index in 0..<starNumber {
                buttons[index].setImage(ImageLiteral.starIcon, for: .normal)
            }
            currentStar = 0
            return
        }
        
        for index in 0...tag {
            buttons[index].setImage(ImageLiteral.fillStarIcon, for: .normal)
        }
        
        for index in tag + 1..<starNumber {
            buttons[index].setImage(ImageLiteral.starIcon, for: .normal)
        }
        
        currentStar = tag + 1
    }
    
    private func updateStars() {
        for index in 0..<starNumber {
            if index < currentStar {
                buttons[index].setImage(ImageLiteral.fillStarIcon, for: .normal)
            } else {
                buttons[index].setImage(ImageLiteral.starIcon, for: .normal)
            }
        }
    }
    
    override func setHierarchy() {
        [rateTitleLabel, containerView].forEach {
            self.addSubview($0)
        }
        
        containerView.addSubview(stackView)
    }
    
    override func setConstraints() {
        rateTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(rateTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func setLayout() {
        backgroundColor = .clear
        containerView.backgroundColor = .white
    }
}
