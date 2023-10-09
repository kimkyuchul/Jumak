//
//  DetailTitleView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailTitleView: BaseView {
    
    fileprivate let hashTagLabel: UILabel = {
        let label = UILabel()
        label.text = "#막걸리"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.thinLineSeed(size: ._14)
        return label
    }()
    fileprivate let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._20)
        return label
    }()
    fileprivate let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "막걸리가 1.2KM 떨어져있어요!"
        label.applyColor(to: "1.2KM", with: .pink)
        label.textAlignment = .center
        label.textColor = .deepDarkGray
        label.font = UIFont.regularLineSeed(size: ._14)
        return label
    }()
    let bookMarkButton = BookmarkButton()
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    fileprivate let mapButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        let attributedTitle = NSAttributedString(string: "길찾기",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._20),
                                                    .foregroundColor: UIColor.black
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.mapIcon
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.imagePlacement = .leading
        let button = UIButton()
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dropShadow(color: .black, offset: CGSize(width: 0, height: 8.0), opacity: 0.2, radius: 10)
        self.layer.cornerRadius = 23
    }
    
    override func setHierarchy() {
        [hashTagLabel, storeTitleLabel, distanceLabel, bookMarkButton, lineView, mapButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10).priority(.high)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10).priority(.high)
        }
        
        storeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(10).priority(.high)
            make.centerX.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(storeTitleLabel.snp.bottom).offset(5).priority(.high)
            make.centerX.equalToSuperview()
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(10).priority(.low)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(bookMarkButton.snp.height)
            make.width.equalTo(1)
            make.leading.equalTo(bookMarkButton.snp.trailing).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(bookMarkButton.snp.bottom)
        }
        
        mapButton.snp.makeConstraints { make in
            make.centerY.equalTo(bookMarkButton.snp.centerY)
            make.leading.equalTo(lineView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
}

extension Reactive where Base: DetailTitleView {
    var hashTag: Binder<String?> {
        return base.hashTagLabel.rx.text
    }
    
    var placeName: Binder<String?> {
        return base.storeTitleLabel.rx.text
    }
    
    var distance: Binder<String?> {
        return Binder(self.base) { view, distance in
            if let distance = distance, let distanceValue = distance.convertMetersToKilometers() {
                if distanceValue > 15.0 {
                    view.distanceLabel.text = "막걸리가 15KM 이상 떨어져있어요!"
                } else {
                    view.distanceLabel.text = "막걸리가 \(distanceValue)KM 떨어져있어요!"
                }
            }
        }
    }
}
