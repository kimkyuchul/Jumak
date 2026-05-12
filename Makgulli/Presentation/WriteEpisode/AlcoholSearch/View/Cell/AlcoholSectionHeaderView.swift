//
//  AlcoholSectionHeaderView.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

import SnapKit

final class AlcoholSectionHeaderView: UICollectionReusableView {

    private let letterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._20)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(letterLabel)
        letterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        letterLabel.text = nil
    }

    func configure(letter: Character) {
        letterLabel.text = String(letter).uppercased()
    }
}
