//
//  BaseViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import UIKit

import Reachability
import RxReachability
import RxSwift
import SnapKit

class BaseViewController: UIViewController, BaseViewControllerProtocol, BaseBindableProtocol {
    
    var disposeBag: DisposeBag = .init()
    var reachability: Reachability?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "remove required init")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            reachability = try Reachability()
        } catch {
            print("Reachability 에러: \(error)")
        }
        
        bind()
        bindAction()
        bindReachability()
        setHierarchy()
        setConstraints()
        setLayout()
        setNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setHierarchy() { }
    func setConstraints() { }
    func setLayout() { }
    func setNavigationBar() { }
    func bind() { }
    func bindAction() { }
    func bindReachability() {
        reachability?.rx.isDisconnected
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
}
