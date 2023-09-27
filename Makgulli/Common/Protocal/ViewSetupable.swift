//
//  ViewSetupable.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

protocol ViewSetupable {
    func setHierarchy()
    func setConstraints()
    func setLayout()
}

protocol BaseViewProtocol: AnyObject, ViewSetupable {}

protocol BaseViewControllerProtocol: AnyObject, ViewSetupable {
    func setNavigationBar()
}

protocol BaseBindableProtocol: AnyObject, ViewSetupable {
    func bind()
}
