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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHierarchy()
        setConstraints()
        setLayout()
        setNavigationBar()
        bind()
        bindAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setHierarchy() { }
    func setConstraints() { }
    func setLayout() {
        self.view.backgroundColor = UIColor.white
    }
    func setNavigationBar() { }
    func bind() { }
    func bindAction() { }
}
