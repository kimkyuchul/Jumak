//
//  QuestionViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

import RxCocoa

final class QuestionViewController: BaseViewController {
    
    private let questionTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._24)
        label.text = "주막이 궁금해요 👀"
        return label
    }()
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.xmarkIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleToFill
        button.backgroundColor = .clear
        return button
    }()
    private let questionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = ImageLiteral.makgulliImage
        return imageView
    }()
    private let questionContentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._16)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text =
        """
        ‘주막’은 주변막걸리의 약자로
        내 주위의 맛있는 막걸리 주막을 찾을 수 있습니다.
        키워드 기반으로 주막을 찾고 그날의 에피소드 기록이 가능한 서비스 입니다.🍶
        """
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheet()
        
        dismissButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
    }
    
    override func setHierarchy() {
        [questionTitleLabel, dismissButton, questionImageView, questionContentLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        questionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(30)
        }
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(30)
            make.size.equalTo(30)
        }
        
        questionImageView.snp.makeConstraints { make in
            make.top.equalTo(questionTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(UIDevice.current.hasNotch ? 200 : 180)
        }
        
        questionContentLabel.snp.makeConstraints { make in
            make.top.equalTo(questionImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(20).priority(.low)
        }
    }
    
    override func setLayout() {
        view.backgroundColor = .lightGray
    }
}
