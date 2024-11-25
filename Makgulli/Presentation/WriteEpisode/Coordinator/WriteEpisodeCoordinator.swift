//
//  EpisodeCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/24/24.
//

import UIKit

final class WriteEpisodeCoordinator: Coordinator {
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    var store: StoreVO?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        debugPrint("deinit Coordinator: \(self)")
    }
    
    func start() {
        guard let store else { return }
        
        let viewModel = AppDIContainer.shared.makeEpisodeDIContainer().makeWriteEpisodeViewModel(store: store)
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
