//
//  AlcoholicBeverageListDIContainer.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

final class AlcoholicBeverageListDIContainer {
    
    struct Dependencies {
        let networkManager: NetworkManager
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    private func makeAlcoholicBeverageListRepository() -> AlcoholicBeverageListRepository {
        DefaultAlcoholicBeverageListRepository(networkManager: dependencies.networkManager)
    }
    
    // MARK: - UseCases
    private func makeAlcoholicBeverageUseCase() -> AlcoholicBeverageUseCase {
        DefaultAlcoholicBeverageUseCase(repository: makeAlcoholicBeverageListRepository())
    }
    
    // MARK: - ViewModel
    func makeAlcoholicBeverageViewModel() -> AlcoholicBeverageListViewModel {
        AlcoholicBeverageListViewModel(useCase: makeAlcoholicBeverageUseCase())
    }
}
