//
//  RateView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa

final class RateView: BaseView {
        
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 2
        return view
    }()
    
    private var starNumber: Int = 5 {
        didSet { bind() }
    }
    private var currentStar: Int = 0
    private var buttons: [UIButton] = []
    var rateValueSubject = PublishSubject<Int>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        starNumber = 5
        backgroundColor = .clear
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
            rateValueSubject.onNext(0)
            return
        }
        
        for index in 0...tag {
            buttons[index].setImage(ImageLiteral.fillStarIcon, for: .normal)
        }
        
        for index in tag + 1..<starNumber {
            buttons[index].setImage(ImageLiteral.starIcon, for: .normal)
        }
        
        currentStar = tag + 1
        rateValueSubject.onNext(currentStar)
    }
    
    override func setHierarchy() {
        self.addSubview(stackView)
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
