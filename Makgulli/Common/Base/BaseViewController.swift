//
//  BaseViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import UIKit

import RxSwift
import SnapKit

class BaseViewController: UIViewController, BaseViewControllerProtocol, BaseBindableProtocol {
    
    var disposeBag: DisposeBag = .init()
    
    init() {
         super.init(nibName: nil, bundle: nil)
     }
    
    @available(*, unavailable, message: "remove required init")
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
        setHierarchy()
        setConstraints()
        setLayout()
        setNavigationBar()
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
}
