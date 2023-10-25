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
    func filterReverseButtonTapped(_ void: Void)
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
        button.setImage(ImageLiteral.reserveFilterIcon, for: .normal)
        return button
    }()
    
    weak var bottomSheetDelegate: ShowFilterBottomSheetDelegate?
    weak var filterReverseDelegate: FilterReverseDelegate?
    private var disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        bind()
        setHierarchy()
        setConstraints()
        
        filterButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, event in
                owner.bottomSheetDelegate?.filterButtonTapped()
            })
            .disposed(by: disposeBag)
        
        filterReverseButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, event in
                UserDefaultHandler.reverseFilter.toggle()
                owner.filterReverseDelegate?.filterReverseButtonTapped(())
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        filterReverseButton.rx.tap
            .withUnretained(self)
            .map { !$0.0.filterReverseButton.isSelected }
            .bind(to: filterReverseButton.rx.isSelected)
            .disposed(by: disposeBag)
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
            make.trailing.equalTo(filterReverseButton.snp.leading).offset(-6)
            make.centerY.equalTo(storeCountLabel.snp.centerY)
        }
        
        filterReverseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalTo(storeCountLabel.snp.centerY)
            make.height.equalTo(filterButton.snp.height)
        }
    }
}

extension FilterHeaderView {
    func configure(countTile: Int, filterType: FilterType, reverseFilter: Bool) {
        storeCountLabel.text = "총 \(countTile)개"
        
        var attributedTitle: NSAttributedString
        
        if reverseFilter {
            attributedTitle = self.setNSAttributedString(filterType.titleForReverse(filter: true))
        } else {
            attributedTitle = self.setNSAttributedString(filterType.titleForReverse(filter: false))
        }
        
        filterButton.configuration?.attributedTitle = AttributedString(attributedTitle)
        
        if reverseFilter {
            filterReverseButton.tintColor = .gray
        } else {
            filterReverseButton.tintColor = .black
        }
    }
}
