//
//  LocationDetailCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/24/24.
//

import UIKit

final class LocationDetailCoordinator: Coordinator {
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
            .makeLocationDIContainer()
            .makeLocationDetailViewModel(store: store)
        viewModel.coordinator = self
        
        let locationDetilViewController = LocationDetailViewController(viewModel: viewModel)
        
        locationDetilViewController.hidesBottomBarWhenPushed = true
        push(viewController: locationDetilViewController, navibarHidden: true, swipe: false)
    }
    
    func didFinish() {
        parentCoordinator?.removeDependency(self)
    }
}

extension LocationDetailCoordinator {
    func popLocationDetail() {
        parentCoordinator?.removeDependency(self)
        pop()
    }
    
    func startWriteEpisode(store: StoreVO) {
        let writeEpisodeCoordinator = WriteEpisodeCoordinator(navigationController: navigationController, dependency: dependency)
        writeEpisodeCoordinator.parentCoordinator = self
        writeEpisodeCoordinator.store = store
        writeEpisodeCoordinator.start()
        
        addDependency(writeEpisodeCoordinator)
    }

    func startEpisodeDetail(episode: Episode, storeId: String) {
        let episodeDetailCoordinator = EpisodeDetailCoordinator(navigationController: navigationController, dependency: dependency)
        episodeDetailCoordinator.parentCoordinator = self
        episodeDetailCoordinator.episode = episode
        episodeDetailCoordinator.storeId = storeId
        episodeDetailCoordinator.start()
        
        addDependency(episodeDetailCoordinator)
    }
}


