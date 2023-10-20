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
    fileprivate let rateTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._18)
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
        DispatchQueue.main.async {
            for index in 0..<self.starNumber {
                if index < self.currentStar {
                    self.buttons[index].setImage(ImageLiteral.fillStarIcon, for: .normal)
                } else {
                    self.buttons[index].setImage(ImageLiteral.starIcon, for: .normal)
                }
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
            make.height.equalToSuperview().offset(-42)
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func setLayout() {
        backgroundColor = .clear
    }
}

extension Reactive where Base: DetailRateView {
    var rate: Binder<Int> {
        return Binder(self.base) { view, rate in
            UIView.transition(with: view.rateTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                view.rateTitleLabel.text = self.rateTitle(for: rate)
            }, completion: nil)
        }
    }
    
    private func rateTitle(for rate: Int) -> String {
        switch rate {
        case 0: return "막걸리 맛이 어떠셨나요 :)"
        case 1: return "막걸리 맛이 최악이셨군요 :("
        case 2: return "막걸리 맛이 별로셨군요 :/"
        case 3: return "막걸리가 SoSo 하셨군요 :)"
        case 4: return "막걸리를 먹고 흥겨우셨군요 ;)"
        case 5: return "한병 더 가져와 막걸리 막걸리를 ~ :)"
        default: return "막걸리 맛이 어떠셨나요 :)"
        }
    }
}
