//
//  AppDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/03.
//

import Foundation

protocol injector: AnyObject {
    func makeLocationDIContainer() -> LocationDIContainer
    func makeEpisodeDIContainer() -> EpisodeDIContainer
    func makeFavoriteDIContainer() -> FavoriteDIContainer
    func makeAppInfoDIContainer() -> AppInfoDIContainer
    func makeAlcoholicBeverageListDIContainer() -> AlcoholicBeverageListDIContainer
}

final class AppDIContainer: injector {
    private lazy var networkManager = NetworkManager()
    private lazy var imageStorage = DefaultImageStorage(fileManager: FileManager.default)
    
    func makeLocationDIContainer() -> LocationDIContainer {
        let dependencies = LocationDIContainer.Dependencies(
            networkManager: networkManager,
            imageStorage: imageStorage
        )
        
        return LocationDIContainer(dependencies: dependencies)
    }
    
    func makeEpisodeDIContainer() -> EpisodeDIContainer {
        let dependencies = EpisodeDIContainer.Dependencies(
            imageStorage: imageStorage
        )
        
        return EpisodeDIContainer(dependencies: dependencies)
    }
    
    func makeFavoriteDIContainer() -> FavoriteDIContainer {
        return FavoriteDIContainer()
    }
    
    func makeAppInfoDIContainer() -> AppInfoDIContainer {
        return AppInfoDIContainer()
    }
    
    func makeAlcoholicBeverageListDIContainer() -> AlcoholicBeverageListDIContainer {
        let dependencies = AlcoholicBeverageListDIContainer.Dependencies(
            networkManager: networkManager
        )
        
        return AlcoholicBeverageListDIContainer(dependencies: dependencies)
    }
}
