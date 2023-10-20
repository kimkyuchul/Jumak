//
//  EpisodeDateView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

import RxSwift
import RxCocoa

final class EpisodeDateView: BaseView {

    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "전설적인 그날"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        return label
    }()
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    private let dateTextField: EpisodeTextField = {
        let textField = EpisodeTextField()
        textField.isUserInteractionEnabled = false
        return textField
    }()
    fileprivate let datePicker: UIDatePicker = {
        let datepick = UIDatePicker()
        datepick.datePickerMode = .date
        datepick.locale = Locale(identifier: "ko_KR")
        datepick.preferredDatePickerStyle = .compact
        datepick.backgroundColor = .clear
        return datepick
    }()
    private let dateButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .medium
        let attributedTitle = NSAttributedString(string: "Date Pick",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._14),
                                                    .foregroundColor: UIColor.black
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.calendarIcon
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.imagePlacement = .leading
        let button = UIButton()
        button.configuration = configuration
        button.isUserInteractionEnabled = false
        button.backgroundColor = .white
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateTextField.text = Date().formattedDate()
        dateValueChagne()
    }
    
    private func dateValueChagne() {
        datePicker.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.dateTextField.text = owner.datePicker.date.formattedDate()
            })
            .disposed(by: disposeBag)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 14
    }
    
    override func setHierarchy() {
        [episodeTitleLabel, containerView].forEach {
            addSubview($0)
        }
        
        [dateTextField, datePicker, dateButton].forEach {
            containerView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.trailing.equalToSuperview().inset(3)
        }
        
        dateButton.snp.makeConstraints{ make in
            make.trailing.equalTo(datePicker.snp.trailing)
            make.width.equalTo(123)
            make.height.equalTo(datePicker.snp.height)
            make.centerY.equalToSuperview()
        }
    }
}

extension Reactive where Base: EpisodeDateView {
    var date: ControlProperty<Date> {
        return base.datePicker.rx.date
    }
}
