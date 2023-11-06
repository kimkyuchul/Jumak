//
//  DefaultEpisodeDetailRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxSwift

final class DefaultEpisodeDetailRepository: EpisodeDetailRepository {
    private let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func removeImage(fileName: String) -> Completable {
        return imageStorage.removeImageFromDocument(fileName: fileName)
    }
}
