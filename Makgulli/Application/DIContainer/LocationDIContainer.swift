//
//  LocationDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/03.
//

import Foundation

final class LocationDIContainer {

    struct Dependencies {
        let networkManager: NetworkManager<LocationAPI>
        let imageStorage: ImageStorage
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    private func makeSearchLocationRepository() -> SearchLocationRepository {
        DefaultSearchLocationRepository(
            networkManager: dependencies.networkManager
        )
    }
    
    private func makeSearchLocationLocalRepository() -> SearchLocationLocalRepository {
        if let locationStorage = DefaultLocationStorage() {
            return DefaultSearchLocationLocalRepository(
                locationStorage: locationStorage
            )
        } else {
            fatalError("Failed to create LocationStorage")
        }
    }
    
    private func makeLocationDetailRepository() -> LocationDetailRepository {
        DefaultLocationDetailRepository(
            imageStorage: dependencies.imageStorage
        )
    }
    
    private func makeLocationDetailLocalRepository() -> LocationDetailLocalRepository {
        if let locationDetailStorage = DefaultLocationDetailStorage() {
            return DefaultLocationDetailLocalRepository(
                locationDetailStorage: locationDetailStorage
            )
        } else {
            fatalError("Failed to create LocationDetailStorage")
        }
    }

    // MARK: - UseCases
    private func makeLocationUseCase() -> LocationUseCase {
        DefaultLocationUseCase(
            locationService: DefaultLocationManager()
        )
    }

    private func makeSearchLocationUseCase() -> SearchLocationUseCase {
        DefaultSearchLocationUseCase(
            searchLocationRepository: makeSearchLocationRepository(),
            searchLocationLocalRepository: makeSearchLocationLocalRepository()
        )
    }
    
    private func makeLocationDetailUseCase() -> LocationDetailUseCase {
        DefaultLocationDetailUseCase(
            locationDetailRepository: makeLocationDetailRepository(),
            locationDetailLocalRepository: makeLocationDetailLocalRepository(),
            urlSchemaService: DefaultURLSchemaService(),
            pasteboardService: DefaultPasteboardService()
        )
    }
    
    // MARK: - ViewModel
    func makeLocationViewModel() -> LocationViewModel {
        LocationViewModel(
            searchLocationUseCase: makeSearchLocationUseCase(),
            locationUseCase: makeLocationUseCase()
        )
    }
    
    func makeLocationDetailViewModel(store: StoreVO) -> LocationDetailViewModel {
        LocationDetailViewModel(
            storeVO: store,
            locationDetailUseCase: makeLocationDetailUseCase()
        )
    }
}
