//
//  WriteEpisodeDetailUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxSwift

protocol EpisodeDetailUseCase: AnyObject {
    func deleteEpisode(storeId: String, episodeId: String, imageFileName: String) -> Completable
}

final class DefaultEpisodeDetailUseCase: EpisodeDetailUseCase {
    enum EpisodeDetailError: Error {
        case deleteEpisode
        case deleteEpisodeImage
    }

    private let episodeDetailRepository: EpisodeDetailRepository
    private let episodeDetailLocalRepository: EpisodeDetailLocalRepository

    init(episodeDetailRepository: EpisodeDetailRepository,
         episodeDetailLocalRepository: EpisodeDetailLocalRepository
    ) {
        self.episodeDetailRepository = episodeDetailRepository
        self.episodeDetailLocalRepository = episodeDetailLocalRepository
    }

    func deleteEpisode(storeId: String, episodeId: String, imageFileName: String) -> Completable {
        let realmDelete = episodeDetailLocalRepository.deleteEpisode(id: storeId, episodeId: episodeId)
            .catch { _ in .error(EpisodeDetailError.deleteEpisode) }
        let imageDelete = episodeDetailRepository.removeImage(fileName: imageFileName)
            .catch { _ in .error(EpisodeDetailError.deleteEpisodeImage) }

        return Completable.zip(realmDelete, imageDelete)
    }
}
