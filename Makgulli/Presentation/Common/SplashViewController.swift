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
        view.addSubview(imageView)
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    override func setLayout() {
        view.backgroundColor = .white
    }
}
