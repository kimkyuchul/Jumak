//
//  FavoriteDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

final class FavoriteDIContainer {
    
    // MARK: - Repository
    private func makeFavoriteRepository() -> FavoriteRepository {
        if let favoriteStorage = DefaultFavoriteStorage() {
            return DefaultFavoriteRepository(
                favoriteStorage: favoriteStorage)
        } else {
            fatalError("Failed to create favoriteStorage")
        }
    }
    
    // MARK: - UseCases
    private func makeFavoriteUseCase() -> FavoriteUseCase {
        DefaultFavoriteUseCase(
            favoriteRepository: makeFavoriteRepository()
        )
    }
    
    // MARK: - ViewModel
    func makeFavoriteViewModel() -> FavoriteViewModel {
        FavoriteViewModel(
            favoriteUseCase: makeFavoriteUseCase()
        )
    }
}
