//
//  EpisodeButton.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import UIKit

final class EpisodeButton: UIButton {
        
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = .brown
            }
            else {
                self.backgroundColor = .gray
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        setTitle(title, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
    }
    
    private func setUp() {
        heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setLayout() {
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .boldLineSeed(size: ._18)
        
    }
}
