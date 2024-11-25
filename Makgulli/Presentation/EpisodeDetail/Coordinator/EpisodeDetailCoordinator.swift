//
//  EpisodeDetailCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/24/24.
//

import UIKit

final class EpisodeDetailCoordinator: Coordinator {
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    var episode: Episode?
    var storeId: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        debugPrint("deinit Coordinator: \(self)")
    }
    
    func start() {
        guard let episode, let storeId else { return }
        
        let viewModel = AppDIContainer.shared.makeEpisodeDIContainer().makeEpisodeDetailViewModel(episode: episode, storeId: storeId)
        viewModel.coordinator = self
       
        let viewController = EpisodeDetailViewController(viewModel: viewModel)
        push(viewController: viewController, swipe: false)
    }
}

extension EpisodeDetailCoordinator {
    func popEpisodeDetail() {
        parentCoordinator?.removeDependency(self)
        pop()
    }
}
