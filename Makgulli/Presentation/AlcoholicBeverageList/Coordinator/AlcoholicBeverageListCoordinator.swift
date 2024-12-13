//
//  AlcoholicBeverageListCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import UIKit

final class AlcoholicBeverageListCoordinator: Coordinator {
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
            .makeAlcoholicBeverageListDIContainer()
            .makeAlcoholicBeverageViewModel()
        
        let alcoholicBeverageListViewController = AlcoholicBeverageListViewController(viewModel: viewModel)
        
        push(viewController: alcoholicBeverageListViewController, navibarHidden: false, animated: false)
    }
}
