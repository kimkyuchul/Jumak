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
    func loadImageFromDocument(fileName: String) -> Single<Data>
    func loadDataSourceImageFromDocument(fileName: String) -> Data?
}


final class DefaultImageStorage: ImageStorage  {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    enum FileManagerError: Error {
        case documentDirectoryNotFound
        case fileExists
        
        var description: String {
            switch self {
            case .documentDirectoryNotFound: return "파일 시스템 에러가 발생했습니다."
            case .fileExists: return "해당 파일이 존재하지 않습니다."
            }
        }
    }
    
    func saveImageDataToDocument(fileName: String, imageData: Data) -> Completable {
        return Completable.create { completable in
            guard let documentDirectory = self.fileManager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                completable(.error(FileManagerError.documentDirectoryNotFound))
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
    
    func loadImageFromDocument(fileName: String) -> Single<Data> {
        return Single.create { single in
            guard let documentDirectory = self.fileManager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                single(.failure(FileManagerError.documentDirectoryNotFound))
                return Disposables.create()
            }
            
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            if self.fileManager.fileExists(atPath: fileURL.path) {
                if let data = try? Data(contentsOf: fileURL) {
                    single(.success(data))
                }
            } else {
                single(.failure(FileManagerError.fileExists))
            }
            return Disposables.create()
        }
    }
    
    func loadDataSourceImageFromDocument(fileName: String) -> Data? {
        guard let documentDirectory = self.fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }
        
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        if self.fileManager.fileExists(atPath: fileURL.path) {
            let data = try? Data(contentsOf: fileURL)
            return data
            
        } else {
            return nil
        }
    }
}
