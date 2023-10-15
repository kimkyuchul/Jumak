//
//  EpisodeTextField.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/11.
//

import UIKit

final class EpisodeTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraints()
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholderText: String) {
        self.init()
        placeholder = placeholderText
        setPlaceholder()
    }
    
    convenience init(height: CGFloat) {
        self.init()
        
        self.snp.remakeConstraints { make in
            make.height.equalTo(height)
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 14
    }
}

extension EpisodeTextField {
    private func setLayout() {
        clipsToBounds = true
        textColor = .black
        tintColor = .gray
        font = UIFont.regularLineSeed(size: ._14)
        backgroundColor = .white
        clearButtonMode = .whileEditing
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        setPadding()
    }
    
    private func setConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func setPlaceholder() {
        if let placeholderText = placeholder {
            let placeholderAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        }
    }
    
    private func setPadding() {
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
         leftView = paddingView
         rightView = paddingView
         leftViewMode = ViewMode.always
         rightViewMode = ViewMode.always
     }
}
