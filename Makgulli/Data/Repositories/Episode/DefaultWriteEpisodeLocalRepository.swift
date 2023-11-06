//
//  DefaultWriteEpisodeLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

final class DefaultWriteEpisodeLocalRepository: WriteEpisodeLocalRepository {
    private let episodeStorage: EpisodeStorage
    private let locationDetailStorage: LocationDetailStorage
    
    init(episodeStorage: EpisodeStorage,
         locationDetailStorage: LocationDetailStorage
    ) {
        self.episodeStorage = episodeStorage
        self.locationDetailStorage = locationDetailStorage
    }
    
    func createStore(_ store: StoreVO) -> Completable {
        locationDetailStorage.createStore(store)
    }
    
    func createStoreTable(_ store: StoreTable) -> Completable {
        episodeStorage.createStoreTable(store)
    }
    
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable {
        episodeStorage.updateEpisode(id: id, episode: episode)
    }
    
    func checkContainsStore(_ id: String) -> Bool {
        locationDetailStorage.checkContainsStore(id)
    }
}
