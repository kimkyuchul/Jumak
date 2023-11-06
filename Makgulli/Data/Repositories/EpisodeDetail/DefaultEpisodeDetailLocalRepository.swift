//
//  DefaultEpisodeDetailLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

final class DefaultEpisodeDetailLocalRepository: EpisodeDetailLocalRepository {
    private let episodeDetailStorage: EpisodeDetailStorage
    
    init(episodeDetailStorage: EpisodeDetailStorage) {
        self.episodeDetailStorage = episodeDetailStorage
    }
    
    func deleteEpisode(id: String, episodeId: String) -> Completable {
        episodeDetailStorage.deleteEpisode(id: id, episodeId: episodeId)
    }
}
