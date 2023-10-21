//
//  BookmarkButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import UIKit

import RxSwift
import RxCocoa

final class BookmarkButton: UIButton {
    
    var disposeBag: DisposeBag = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConfiguration()
        buttonConfigurationUpdateHandler()
        bind()
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConfiguration() {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        let attributedTitle = NSAttributedString(string: "즐겨찾기",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._16),
                                                    .foregroundColor: UIColor.pink
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.baseForegroundColor = UIColor.pink
        configuration.background.backgroundColor = .clear
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.imagePlacement = .leading
        self.configuration = configuration
    }
    
    private func buttonConfigurationUpdateHandler() {
        self.configurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.image = ImageLiteral.fillHeartIcon
                button.configuration?.baseBackgroundColor = .clear
            case .normal:
                button.configuration?.image = ImageLiteral.heartIcon
            default:
                break
            }
        }
    }
    
    private func bind() {
        self.rx.tap
            .withUnretained(self)
            .map { !$0.0.self.isSelected }
            .bind(to: self.rx.isSelected)
            .disposed(by: disposeBag)
    }
}

extension BookmarkButton {
    private func setLayout() {
        self.backgroundColor = UIColor.clear
    }
}
