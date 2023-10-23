//
//  SplashViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

import Reachability
import RxReachability
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
        
        Reachability.rx.isConnected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                RootHandler.shard.update(.main)
            })
            .disposed(by: disposeBag)
        
        
        Reachability.rx.isDisconnected
            .withUnretained(self)
            .flatMap { owner, _ in
                return owner.rx.makeErrorAlert(
                    title: "네트워크 연결 오류",
                    message: "네트워크 연결이 불안정 합니다.",
                    cancelButtonTitle: "확인"
                )
            }
            .subscribe()
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
