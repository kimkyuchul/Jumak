//
//  DetailInfoView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/06.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailInfoView: BaseView {
    
    private let rateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 상세 정보"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._20)
        return label
    }()
    private let copyAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.copyIcon, for: .normal)
        button.tintColor = .deepDarkGray
        button.backgroundColor = .clear
        return button
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 타입"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    fileprivate let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(typeTitleLabel, typeLabel)
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 주소"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    fileprivate let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(addressTitleLabel, addressLabel)
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private let roadAddressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "도로 주소"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    fileprivate let roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    private lazy var roadAddressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(roadAddressTitleLabel, roadAddressLabel)
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private let phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가게 번호"
        label.font = UIFont.boldLineSeed(size: ._16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    fileprivate let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularLineSeed(size: ._16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    private lazy var phoneStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(phoneTitleLabel, phoneLabel)
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(typeStackView, addressStackView, roadAddressStackView, phoneStackView)
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 23
    }
    
    override func setHierarchy() {
        [rateTitleLabel, copyAddressButton, containerView].forEach {
            self.addSubview($0)
        }
        
        containerView.addSubview(stackView)
    }
    
    override func setConstraints() {
        rateTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        copyAddressButton.snp.makeConstraints { make in
            make.centerY.equalTo(rateTitleLabel.snp.centerY)
            make.leading.equalTo(rateTitleLabel.snp.trailing).offset(6).priority(.high)
            make.height.equalTo(rateTitleLabel.snp.height).multipliedBy(0.9)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(rateTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    override func setLayout() {
        backgroundColor = .clear
    }
}

extension Reactive where Base: DetailInfoView {
    var type: Binder<String?> {
        return base.typeLabel.rx.text
    }
    
    var address: Binder<String?> {
        return base.addressLabel.rx.text
    }
    
    var roadAddress: Binder<String?> {
        return base.roadAddressLabel.rx.text
    }
        
    var phone: Binder<String?> {
        return Binder(self.base) { view, phone in
            if let phone = phone, phone.isEmpty {
                view.phoneLabel.text = "전화번호 정보가 없어요."
            } else {
                view.phoneLabel.text = phone
            }
        }
    }
}

