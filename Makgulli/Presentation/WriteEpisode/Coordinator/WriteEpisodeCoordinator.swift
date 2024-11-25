//
//  EpisodeCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/24/24.
//

import UIKit

final class WriteEpisodeCoordinator: Coordinator {
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    var store: StoreVO?
    
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
        guard let store else { return }
        
        let viewModel = dependency
            .makeEpisodeDIContainer()
            .makeWriteEpisodeViewModel(store: store)
        viewModel.coordinator = self

        let viewController = WriteEpisodeViewController(viewModel: viewModel)
        present(viewController, style: .fullScreen)
    }
}

extension WriteEpisodeCoordinator {
    func dismissWriteEpisode() {
        parentCoordinator?.removeDependency(self)
        dismiss()
    }
}
