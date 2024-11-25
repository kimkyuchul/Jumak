//
//  AppInfoCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/25/24.
//

import UIKit
import SafariServices

final class AppInfoCoordinator: Coordinator {
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        debugPrint("deinit Coordinator: \(self)")
    }
    
    func start() {
        let viewModel = AppDIContainer.shared
            .makeAppInfoDIContainer()
            .makeAppInfoViewModel()
        viewModel.coordinator = self
       
        let viewController = AppInfoViewController(viewModel: viewModel)
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
