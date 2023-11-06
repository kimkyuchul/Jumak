//
//  EpisodeDetailLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

protocol EpisodeDetailLocalRepository: AnyObject {
    func deleteEpisode(id: String, episodeId: String) -> Completable
}
