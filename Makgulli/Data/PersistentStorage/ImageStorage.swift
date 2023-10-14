//
//  ImageStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/13.
//

import Foundation

import RxSwift

protocol ImageStorage {
    func saveImageDataToDocument(fileName: String, imageData: Data) -> Completable
}

final class DefaultImageStorage: ImageStorage  {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    enum FileManagerError: Error {
        case documentDirectoryNotFound
        
        var description: String {
            switch self {
            case .documentDirectoryNotFound: return "파일 시스템 에러가 발생했습니다."
            }
        }
    }
    
    func saveImageDataToDocument(fileName: String, imageData: Data) -> Completable {
        return Completable.create { completable in
            guard let documentDirectory = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { completable(.error(FileManagerError.documentDirectoryNotFound))
                return Disposables.create()
            }
            
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                try imageData.write(to: fileURL)
                completable(.completed)
            } catch let error {
                print("image File save error", error)
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}
