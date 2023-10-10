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
                self.backgroundColor = .gray
            }
            else {
                self.backgroundColor = .brown
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
        self.layer.cornerRadius = 6
    }
    
    private func setUp() {
        heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    private func setLayout() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = .boldLineSeed(size: ._18)
        
    }
}
