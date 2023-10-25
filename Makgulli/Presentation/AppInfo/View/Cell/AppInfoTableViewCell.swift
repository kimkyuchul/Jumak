//
//  AppInfoTableViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/25.
//

import UIKit

final class AppInfoTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularLineSeed(size: ._18)
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .regularLineSeed(size: ._18)
        label.isHidden = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setConstraints()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setHierarchy() {
        [titleLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.centerY.equalTo(titleLabel.snp.centerY)

        }
    }
    
    private func setLayout() {
        self.backgroundColor = .clear
        selectionStyle = .none
    }
}

extension AppInfoTableViewCell {
    func configureCell(item: String) {
        titleLabel.text = item
    }
    
    func configureAppVersion(version: String) {
        contentLabel.isHidden = false
        contentLabel.text = version
    }
}
