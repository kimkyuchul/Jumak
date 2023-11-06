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
    
    private func makeEpisodeDetailRepository() -> EpisodeDetailRepository {
        DefaultEpisodeDetailRepository(
            imageStorage: DefaultImageStorage(fileManager: FileManager())
        )
    }
    
    private func makeEpisodeDetailLocalRepository() -> EpisodeDetailLocalRepository {
        if let episodeDetailStorage = DefaultEpisodeDetailStorage() {
            return DefaultEpisodeDetailLocalRepository(
                episodeDetailStorage: episodeDetailStorage
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
    
    private func makeEpisodeDetailUseCase() -> EpisodeDetailUseCase {
        DefaultEpisodeDetailUseCase(
            episodeDetailRepository: makeEpisodeDetailRepository(),
            episodeDetailLocalRepository: makeEpisodeDetailLocalRepository()
        )
    }
    
    // MARK: - ViewModel
    func makeLocationViewModel(store: StoreVO) -> WriteEpisodeViewModel {
        WriteEpisodeViewModel(
            storeVO: store,
            writeEpisodeUseCase: makeLocationUseCase()
        )
    }
    
    func makeLocationViewModel(episode: Episode, storeId: String) -> EpisodeDetailViewModel {
        EpisodeDetailViewModel(
            episode: episode,
            storeId: storeId,
            episodeDetailUseCase: makeEpisodeDetailUseCase()
        )
    }
}
