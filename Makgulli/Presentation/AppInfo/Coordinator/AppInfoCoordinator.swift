//
//  AppInfoCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/25/24.
//

import UIKit
import SafariServices

final class AppInfoCoordinator: Coordinator {
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    private let dependency: injector
    
    init(
        navigationController: UINavigationController,
        dependency: injector
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    deinit {
        debugPrint("deinit Coordinator: \(self)")
    }
    
    func start() {
        let viewModel = dependency
            .makeAppInfoDIContainer()
            .makeAppInfoViewModel()
        viewModel.coordinator = self
        
        let viewController = AppInfoViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        push(viewController: viewController, navibarHidden: true, swipe: false)
    }
}

extension AppInfoCoordinator {
    func popAppInfo() {
        parentCoordinator?.removeDependency(self)
        pop()
    }
    
    func startInquiry() {
        let viewController = InquiryViewController()
        push(viewController: viewController, swipe: false)
    }
    
    func startSafariWebView(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, style: .automatic)
    }
}
