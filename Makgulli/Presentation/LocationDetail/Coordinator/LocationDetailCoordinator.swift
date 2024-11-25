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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        debugPrint("deinit Coordinator: \(self)")
    }
    
    func start() {
        guard let store else { return }
        
        let viewModel = AppDIContainer.shared
            .makeLocationDIContainer()
            .makeLocationDetailViewModel(store: store)
        viewModel.coordinator = self
        
        let locationDetilViewController = LocationDetailViewController(viewModel: viewModel)
        
        locationDetilViewController.hidesBottomBarWhenPushed = true
        push(viewController: locationDetilViewController, navibarHidden: true, swipe: false)
    }
}

extension LocationDetailCoordinator {
    func popLocationDetail() {
        parentCoordinator?.removeDependency(self)
        pop()
    }
    
    func startWriteEpisode(store: StoreVO) {
        let writeEpisodeCoordinator = WriteEpisodeCoordinator(navigationController: navigationController)
        writeEpisodeCoordinator.parentCoordinator = self
        writeEpisodeCoordinator.store = store
        writeEpisodeCoordinator.start()
        
        addDependency(writeEpisodeCoordinator)
    }

    func startEpisodeDetail(episode: Episode, storeId: String) {
        let episodeDetailCoordinator = EpisodeDetailCoordinator(navigationController: navigationController)
        episodeDetailCoordinator.parentCoordinator = self
        episodeDetailCoordinator.episode = episode
        episodeDetailCoordinator.storeId = storeId
        episodeDetailCoordinator.start()
        
        addDependency(episodeDetailCoordinator)
    }
}


