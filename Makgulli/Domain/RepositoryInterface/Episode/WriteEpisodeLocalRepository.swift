//
//  WriteEpisodeLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

protocol WriteEpisodeLocalRepository: AnyObject {
    func createStore(_ store: StoreVO) -> Completable
    func createStoreTable(_ store: StoreTable) -> Completable
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable
    func checkContainsStore(_ id: String) -> Bool
}
