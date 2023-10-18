//
//  FilterTableViewCell.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldLineSeed(size: ._18)
        label.textColor = .black
        return label
    }()
    private let reverseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageLiteral.fillHeartIcon
        return imageView
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
        [titleLabel, reverseImageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        reverseImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.size.equalTo(30)
        }
    }
    
    private func setLayout() {
        self.backgroundColor = .clear
    }
}

extension FilterTableViewCell {
    func configureCell(type: FilterType) {
        titleLabel.text = type.title
    }
}
