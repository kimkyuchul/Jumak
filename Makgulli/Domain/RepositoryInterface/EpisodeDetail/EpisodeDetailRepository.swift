//
//  EpisodeDetailRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxSwift

protocol EpisodeDetailRepository: AnyObject {
    func removeImage(fileName: String) -> Completable
}
