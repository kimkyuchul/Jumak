//
//  LocationCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/23/24.
//

import UIKit

final class LocationCoordinator: Coordinator {
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
            .makeLocationDIContainer()
            .makeLocationViewModel()
        viewModel.coordinator = self
        
        let locationViewController = LocationViewController(viewModel: viewModel)
        
        push(viewController: locationViewController, navibarHidden: false, animated: false)
    }
}

extension LocationCoordinator {
    func startLocationDetail(_ store: StoreVO) {
        let locationDetailCoordinator = LocationDetailCoordinator(navigationController: navigationController, dependency: dependency)
        locationDetailCoordinator.parentCoordinator = self
        locationDetailCoordinator.store = store
        locationDetailCoordinator.start()
        
        addDependency(locationDetailCoordinator)
    }
    
    func startQuestion() {
        let questionViewController = QuestionViewController()
        present(questionViewController, style: .automatic)
    }
}
