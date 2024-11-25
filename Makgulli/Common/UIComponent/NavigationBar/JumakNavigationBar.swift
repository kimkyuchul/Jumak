//
//  JumakNavigationBar.swift
//  Makgulli
//
//  Created by kyuchul on 11/25/24.
//

import UIKit

import RxSwift
import RxCocoa

final class JumakNavigationBar: BaseView {
    
    private let containerView = UIView()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.back, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textAlignment = .center
        return label
    }()
    
    private var rightItems: [UIView] = []
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    init(rightItems: [UIView] = []) {
        self.rightItems = rightItems
        super.init(frame: .zero)
        configureRightItems()
    }
            
    override func setHierarchy() {
        addSubview(containerView)
        
        [backButton, titleLabel, rightStackView]
            .forEach {
                containerView.addSubview($0)
            }
    }
    
    override func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        rightStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setLayout() {
        self.backgroundColor = .white
    }
}

private extension JumakNavigationBar {
    func configureRightItems() {
        rightItems.forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(26)
            }
        }
        
        rightItems.forEach { rightStackView.addArrangedSubview($0) }
    }
}

extension JumakNavigationBar {
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
            
    func hideBackButton() {
        backButton.isHidden = true
    }
    
    func backButtonAction() -> Observable<Void> {
        return backButton.rx.tap.asObservable()
    }
}
