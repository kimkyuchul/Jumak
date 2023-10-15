//
//  DefaultLocationDetailRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/14.
//

import Foundation

import RxSwift

final class DefaultLocationDetailRepository: LocationDetailRepository {
    private let imageStorage: ImageStorage
    
    init(imageStorage: ImageStorage) {
        self.imageStorage = imageStorage
    }
        
    func loadDataSourceImage(fileName: String) -> Data? {
        return imageStorage.loadDataSourceImageFromDocument(fileName: fileName)
    }
}
