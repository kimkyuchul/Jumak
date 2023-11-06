//
//  AppDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/03.
//

import Foundation


final class AppDIContainer {
    
    static let shared = AppDIContainer()
    
    private init() {}
    
    lazy var networkManager = NetworkManager<LocationAPI>()
    
    func makeLocationDIContainer() -> LocationDIContainer {
        let dependencies = LocationDIContainer.Dependencies(
            networkManager: networkManager
        )
        return LocationDIContainer(dependencies: dependencies)
    }
    
    func makeEpisodeDIContainer() -> EpisodeDIContainer {
        return EpisodeDIContainer()
    }
}
