//
//  AlcoholSectionHeaderView.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

import SnapKit

final class AlcoholSectionHeaderView: UICollectionReusableView {

    private let accentBar: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        return view
    }()

    private let letterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldLineSeed(size: ._20)
        label.textColor = .brown
        return label
    }()

    private let bottomHairline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brown.withAlphaComponent(0.18)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        [accentBar, letterLabel, bottomHairline].forEach { addSubview($0) }

        accentBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(4)
            make.height.equalTo(22)
        }

        letterLabel.snp.makeConstraints { make in
            make.leading.equalTo(accentBar.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        bottomHairline.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
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
