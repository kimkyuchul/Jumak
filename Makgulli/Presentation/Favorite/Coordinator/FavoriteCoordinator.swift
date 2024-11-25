//
//  FavoriteCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/23/24.
//

import UIKit

final class FavoriteCoordinator: Coordinator {
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
    
    func start() {
        let viewModel = dependency
            .makeFavoriteDIContainer()
            .makeFavoriteViewModel()
        viewModel.coordinator = self
        
        let favoriteViewController = FavoriteViewController(viewModel: viewModel)
        
        push(viewController: favoriteViewController, navibarHidden: false, animated: false)
    }
}

extension FavoriteCoordinator {
    func startLocationDetail(_ store: StoreVO) {
        let locationDetailCoordinator = LocationDetailCoordinator(navigationController: navigationController, dependency: dependency)
        locationDetailCoordinator.parentCoordinator = self
        locationDetailCoordinator.store = store
        locationDetailCoordinator.start()
        
        addDependency(locationDetailCoordinator)
    }
    
    func startAppInfo() {
        let appInfoCoordinator = AppInfoCoordinator(navigationController: navigationController, dependency: dependency)
        appInfoCoordinator.parentCoordinator = self
        appInfoCoordinator.start()
        
        addDependency(appInfoCoordinator)
    }
}
