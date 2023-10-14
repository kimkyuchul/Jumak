//
//  DefaultWriteEpisodeRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/14.
//

import Foundation

import RxSwift

final class DefaultWriteEpisodeRepository: WriteEpisodeRepository {
    private let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
    
    func saveImage(fileName: String, imageData: Data) -> Completable {
        return imageStorage.saveImageDataToDocument(fileName: fileName, imageData: imageData)
    }
}
