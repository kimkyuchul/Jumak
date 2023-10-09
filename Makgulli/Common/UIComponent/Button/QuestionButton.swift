//
//  QuestionButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/29.
//

import UIKit

final class QuestionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dropShadow()
        setLayout()
        setConstraints()
        
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

extension QuestionButton {
    private func setLayout() {
        self.backgroundColor = UIColor.white
        self.setImage(ImageLiteral.mapQuestionIcon, for: .normal)
        self.tintColor = UIColor.brown
    }
    
    private func setConstraints() {
        self.snp.makeConstraints { make in
            make.size.equalTo(46)
        }
    }
}
