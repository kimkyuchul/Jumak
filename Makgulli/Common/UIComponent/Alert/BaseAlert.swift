//
//  BaseAlert.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import UIKit

import RxCocoa
import RxSwift

typealias ButtonAction = () -> Void?

final class BaseAlert: UIViewController {
    
    private let contentView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        v.backgroundColor = .white
        return v
    }()
    private lazy var buttonStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fillEqually
        v.addArrangedSubviews(leftButton, rightButton)
        return v
    }()
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.boldLineSeed(size: ._20)
        v.textColor = .black
        return v
    }()
    private let descriptionLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.regularLineSeed(size: ._16)
        v.numberOfLines = 0
        v.textAlignment = .center
        v.textColor = .black
        return v
    }()
    private let leftButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .brown
        v.titleLabel?.font = UIFont.boldLineSeed(size: ._16)
        v.roundCorners(cornerRadius: 20, maskedCorners: .layerMaxXMinYCorner)
        return v
    }()
    private let rightButton: UIButton = {
        let v = UIButton()
        v.setTitleColor(.deepDarkGray, for: .normal)
        v.titleLabel?.font = UIFont.boldLineSeed(size: ._16)
        return v
    }()
    
    private let disposeBag: DisposeBag = .init()
    private var leftButtonAction: ButtonAction?
    private var rightButtonAction: ButtonAction?
    private var alertType: AlertType
    
    init(alertType: AlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateUI()

        leftButton.rx.tap
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { owner, _ in
                owner.leftButtonAction?()
                owner.dismiss()
            })
            .disposed(by: disposeBag)

        rightButton.rx.tap
            .withUnretained(self)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { owner, _ in
                owner.rightButtonAction?()
                owner.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    
    func present(
        on viewController: UIViewController,
        alertType: AlertType,
        leftButtonAction: ButtonAction? = nil,
        rightButtonAction: ButtonAction? = nil
    ) {
        self.leftButtonAction = leftButtonAction
        self.rightButtonAction = rightButtonAction

        
        viewController.present(self, animated: false) { [weak self] in
            UIView.animate(withDuration: 0.4, animations: {
                self?.contentView.alpha = 1
                self?.view.alpha = 1
            })
        }
    }
        
    private func dismiss() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.contentView.alpha = 0
            self?.view.alpha = 0
        }, completion: { [weak self] flag in
            if flag {
                self?.dismiss(animated: false)
            }
        })
    }
    
    private func setUI() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(buttonStackView)
                
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.alpha = 0
        contentView.alpha = 0
        
        contentView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 308, height: 170))
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16).priority(.high)
            make.centerX.equalToSuperview()
          }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10).priority(.high)
            make.leading.trailing.equalToSuperview().inset(10).priority(.high)
          }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16).priority(.low)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(46)
          }
    }
    
    private func updateUI() {
         titleLabel.text = alertType.title
         descriptionLabel.text = alertType.description
         leftButton.setTitle(alertType.leftButtonTitle, for: .normal)
         rightButton.setTitle(alertType.rightButtonTitle, for: .normal)
    }
}
