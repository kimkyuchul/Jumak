//
//  EpisodeDIContainer.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

final class EpisodeDIContainer {
    
    struct Dependencies {
        let imageStorage: ImageStorage
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Repository
    private func makeWriteEpisodeRepository() -> WriteEpisodeRepository {
        DefaultWriteEpisodeRepository(
            imageStorage: dependencies.imageStorage
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
            imageStorage: dependencies.imageStorage
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
    private func makeWriteEpisodeUseCase() -> WriteEpisodeUseCase {
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
    func makeWriteEpisodeViewModel(store: StoreVO) -> WriteEpisodeViewModel {
        WriteEpisodeViewModel(
            storeVO: store,
            writeEpisodeUseCase: makeWriteEpisodeUseCase()
        )
    }
    
    func makeEpisodeDetailViewModel(episode: Episode, storeId: String) -> EpisodeDetailViewModel {
        EpisodeDetailViewModel(
            episode: episode,
            storeId: storeId,
            episodeDetailUseCase: makeEpisodeDetailUseCase()
        )
    }
}
