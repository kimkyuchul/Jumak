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
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = AppDIContainer.shared
            .makeLocationDIContainer()
            .makeLocationViewModel()
        viewModel.coordinator = self
        
        let locationViewController = LocationViewController(viewModel: viewModel)
        
        push(viewController: locationViewController, navibarHidden: false, animated: false)
    }
}

extension LocationCoordinator {
    func startLocationDetail(_ store: StoreVO) {
        let locationDetailCoordinator = LocationDetailCoordinator(navigationController: navigationController)
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
