//
//  EpisodeDetailCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/24/24.
//

import UIKit

final class EpisodeDetailCoordinator: Coordinator {
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    var episode: Episode?
    var storeId: String?
    
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
        guard let episode, let storeId else { return }
        
        let viewModel = dependency
            .makeEpisodeDIContainer()
            .makeEpisodeDetailViewModel(episode: episode, storeId: storeId)
        viewModel.coordinator = self
       
        let viewController = EpisodeDetailViewController(viewModel: viewModel)
        push(viewController: viewController)
    }
    
    func didFinish() {
        parentCoordinator?.removeDependency(self)
    }
}

extension EpisodeDetailCoordinator {
    func popEpisodeDetail() {
        parentCoordinator?.removeDependency(self)
        pop()
    }
}
