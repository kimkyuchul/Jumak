//
//  AppCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/22/24.
//

import UIKit

import Combine

enum AppFlow {
    case main
    case login
}

final class AppCoordinator: Coordinator {
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    let flow = PassthroughSubject<AppFlow, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    private let dependency: injector
    
    init(
        navigationController: UINavigationController,
        dependency: injector
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
        bindState()
    }
    
    func bindState() {
        flow
            .sink { [weak self] flow in
                switch flow {
                case .main:
                    self?.startTabBar()
                case .login:
                    break
                }
            }
            .store(in: &cancellable)
    }
    
    func start() {
        startSplash()
    }
}

extension AppCoordinator {
    private func startSplash() {
        let splashViewController = SplashViewController(coordinator: self)
        navigationController.setNavigationBarHidden(true, animated: false)
        setViewController(viewController: splashViewController, animated: false)
    }
    
    private func startTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, dependency: dependency)
        tabBarCoordinator.parentCoordinator = self
        tabBarCoordinator.start()
        
        self.addDependency(tabBarCoordinator)
    }
}
