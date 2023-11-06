//
//  EpisodeDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

final class EpisodeDIContainer {
    
    // MARK: - Repository
    private func makeWriteEpisodeRepository() -> WriteEpisodeRepository {
        DefaultWriteEpisodeRepository(
            imageStorage: DefaultImageStorage(fileManager: FileManager())
        )
    }
    
    private func makeWriteEpisodeLocalRepository() -> WriteEpisodeLocalRepository {
        if let episodeStorage = DefaultEpisodeStorage(),
           let locationDetailStorage = DefaultLocationDetailStorage() {
            return DefaultWriteEpisodeLocalRepository(
                episodeStorage: episodeStorage,
                locationDetailStorage: locationDetailStorage
            )
        } else {
            fatalError("Failed to create episodeStorage & locationDetailStorage")
        }
    }

    // MARK: - UseCases
    private func makeLocationUseCase() -> WriteEpisodeUseCase {
        DefaultWriteEpisodeUseCase(
            writeEpisodeRepository: makeWriteEpisodeRepository(),
            writeEpisodeLocalRepository:  makeWriteEpisodeLocalRepository()
        )
    }
    
    // MARK: - ViewModel
    func makeLocationViewModel(store: StoreVO) -> WriteEpisodeViewModel {
        WriteEpisodeViewModel(
            storeVO: store,
            writeEpisodeUseCase: makeLocationUseCase()
        )
    }
}
