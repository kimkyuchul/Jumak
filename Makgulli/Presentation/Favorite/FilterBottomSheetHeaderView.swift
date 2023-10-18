//
//  FilterBottomSheetHeaderView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import UIKit

import RxSwift
import RxCocoa

final class FilterBottomSheetHeaderView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.regularLineSeed(size: ._16)
        label.text = "정렬 기준"
        return label
    }()
    fileprivate let filterChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.regularLineSeed(size: ._16)
        button.setTitleColor(.pink, for: .normal)
        return button
    }()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    override func setHierarchy() {
        [titleLabel, filterChangeButton, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        filterChangeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func setLayout() {
        self.backgroundColor = .white
    }
}

extension Reactive where Base: FilterBottomSheetHeaderView {
    var tapFilterChange: ControlEvent<Void> {
        return base.filterChangeButton.rx.tap
    }
}
