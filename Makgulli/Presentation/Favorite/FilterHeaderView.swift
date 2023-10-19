//
//  FilterHeaderView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol ShowFilterBottomSheetDelegate: AnyObject {
    func filterButtonTapped()
}

protocol FilterReverseDelegate: AnyObject {
    func filterReverseButtonTapped(_ bool: Bool)
}

final class FilterHeaderView: UICollectionReusableView {
    
    private let storeCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let filterButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .mini
        let attributedTitle = NSAttributedString(string: "최근에 담은 순",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._14),
                                                    .foregroundColor: UIColor.black
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.arrowDownIcon
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 4
        configuration.imagePlacement = .trailing
        let button = UIButton()
        button.configuration = configuration
        button.backgroundColor = .clear
        return button
    }()
    private let filterReverseButton: UIButton = {
        let button = UIButton()
        button.setTitle("필터", for: .normal)
        button.titleLabel?.font = UIFont.regularLineSeed(size: ._16)
        button.setTitleColor(.pink, for: .normal)
        return button
    }()
    
    weak var bottomSheetDelegate: ShowFilterBottomSheetDelegate?
    weak var filterReverseDelegate: FilterReverseDelegate?
    private var disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setHierarchy()
        setConstraints()
        
        filterButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, event in
                owner.bottomSheetDelegate?.filterButtonTapped()
            })
            .disposed(by: disposeBag)
        
        let tapFilterReverseButton = filterReverseButton.rx.tap
            .share()
        
        tapFilterReverseButton
            .withUnretained(self)
            .map { !$0.0.filterReverseButton.isSelected }
            .bind(to: filterReverseButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        tapFilterReverseButton
            .withUnretained(self)
            .bind(onNext: { owner, event in
                owner.filterReverseDelegate?.filterReverseButtonTapped(owner.filterReverseButton.isSelected)
            })
            .disposed(by: disposeBag)
        
        NotificationCenterManager.reverseFilter.addObserver()
            .compactMap { $0 as? Bool }
            .withUnretained(self)
            .bind(onNext: { owner, falseTrigger in
                owner.filterReverseDelegate?.filterReverseButtonTapped(falseTrigger)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNSAttributedString(_ title: String) -> NSAttributedString {
        return NSAttributedString(string: title,
                                  attributes: [
                                    .font: UIFont.boldLineSeed(size: ._14),
                                    .foregroundColor: UIColor.black
                                  ])
    }
    
    private func setHierarchy() {
        [storeCountLabel, filterButton, filterReverseButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        storeCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        filterButton.snp.makeConstraints { make in
            make.trailing.equalTo(filterReverseButton.snp.leading).offset(5)
            make.centerY.equalTo(storeCountLabel.snp.centerY)
        }
        
        filterReverseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalTo(storeCountLabel.snp.centerY)
        }
    }
}

extension FilterHeaderView {
    func configure(countTile: Int, filterType: FilterType, reverseFilter: ReverseFilterType) {
        storeCountLabel.text = "총 \(countTile)개"

        var attributedTitle: NSAttributedString

        if reverseFilter == .none {
            attributedTitle = self.setNSAttributedString(filterType.titleForReverse(filter: .none))
        } else {
            attributedTitle = self.setNSAttributedString(filterType.titleForReverse(filter: .reverse))
        }

        filterButton.configuration?.attributedTitle = AttributedString(attributedTitle)
        
        if reverseFilter == .none {
            filterReverseButton.setTitle("정방향이다.", for: .normal)
        } else {
            filterReverseButton.setTitle("역순이다.", for: .normal)
        }
    }
}
