//
//  InquiryButtonView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/25.
//

import UIKit

import RxSwift
import RxCocoa

final class InquiryButtonView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularLineSeed(size: ._14)
        return label
    }()
    fileprivate let inquiryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regularLineSeed(size: ._14)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    convenience init(title: String, buttonTitle: String) {
        self.init()
        titleLabel.text = title
        inquiryButton.setTitle(buttonTitle, for: .normal)
        inquiryButton.setUnderline()
    }
    
    override func setHierarchy() {
        [titleLabel, inquiryButton, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(46)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        inquiryButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func setLayout() {
        self.backgroundColor = .white
    }
}

extension Reactive where Base: InquiryButtonView {
    var tapInquiry: ControlEvent<Void> {
        return base.inquiryButton.rx.tap
    }
}
