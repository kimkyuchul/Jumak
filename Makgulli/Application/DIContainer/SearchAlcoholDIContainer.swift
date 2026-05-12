//
//  SearchAlcoholDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import Foundation

final class SearchAlcoholDIContainer {

    struct Dependencies {
        let networkService: NetworkService
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    private func makeSearchAlcoholRepository() -> SearchAlcoholRepository {
        DefaultSearchAlcoholRepository(networkService: dependencies.networkService)
    }

    func makeSearchAlcoholUseCase() -> SearchAlcoholUseCase {
        DefaultSearchAlcoholUseCase(searchAlcoholRepository: makeSearchAlcoholRepository())
    }

    func makeAlcoholSearchViewModel() -> AlcoholSearchViewModel {
        AlcoholSearchViewModel(searchAlcoholUseCase: makeSearchAlcoholUseCase())
    }
}
