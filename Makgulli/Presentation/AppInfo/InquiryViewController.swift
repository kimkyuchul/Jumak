//
//  InquiryViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/25.
//

import UIKit
import MessageUI
import SafariServices

import RxSwift
import RxCocoa

final class InquiryViewController: BaseViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "궁금한 점이 있으시다면\n아래 연락처를 통해 문의해주세요."
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = .black
        label.font = .boldLineSeed(size: ._20)
        return label
    }()
    private let emailInquiryView = InquiryButtonView(title: "이메일", buttonTitle: StringLiteral.email)
    private let instagramInquiryView = InquiryButtonView(title: "Instagram", buttonTitle: "@jumak.offical")
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(emailInquiryView, instagramInquiryView)
        stackView.axis = .vertical
        return stackView
    }()
    
    override func bindAction() {
        emailInquiryView.rx.tapInquiry
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                guard
                    MFMailComposeViewController.canSendMail()
                else {
                    return
                }
                
                let composeViewController = MFMailComposeViewController()
                composeViewController.mailComposeDelegate = owner
                composeViewController.setToRecipients([StringLiteral.email])
                owner.present(composeViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        instagramInquiryView.rx.tapInquiry
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                guard
                    let url = URL(string: URLLiteral.instagram.trimmingWhitespace()), UIApplication.shared.canOpenURL(url)
                else { return }
                let safariViewController = SFSafariViewController(url: url)
                owner.present(safariViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    override func setHierarchy() {
        [titleLabel, stackView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(18).priority(.high)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(18).priority(.high)
        }
    }
    
    override func setLayout() {
        self.view.backgroundColor = .white
    }
}

extension InquiryViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent, .saved:
            controller.dismiss(animated: true)
        case .cancelled, .failed:
            controller.dismiss(animated: true)
        default:
            controller.dismiss(animated: true)
        }
    }
}
