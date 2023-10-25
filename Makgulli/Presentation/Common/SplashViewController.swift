//
//  SplashViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

import RxSwift

final class SplashViewController: BaseViewController {
    
    private let imageView: UIImageView = {
        let imageVIew = UIImageView()
        imageVIew.image = ImageLiteral.makgulliLogo
        imageVIew.contentMode = .scaleAspectFit
        return imageVIew
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldLineSeed(size: ._34)
        label.textColor = .black
        label.text = "내 주변의 막걸리 찾기"
        return label
    }()
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .boldLineSeed(size: ._24)
        label.textColor = .black
        label.text = "JUMAK"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reachability?.rx.isConnected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                RootHandler.shard.update(.main)
            })
            .disposed(by: disposeBag)
    }
        
    override func setHierarchy() {
        [imageView, titleLabel, subLabel].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.size.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setLayout() {
        view.backgroundColor = .lightGray
    }
}
