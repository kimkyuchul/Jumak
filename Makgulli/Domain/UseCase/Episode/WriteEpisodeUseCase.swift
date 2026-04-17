//
//  WriteEpisodeUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import Foundation

import RxSwift

protocol WriteEpisodeUseCase: AnyObject {
    func updateEpisodeList(_ store: StoreVO, episode: EpisodeVO, imageData: Data) -> Completable
}

final class DefaultWriteEpisodeUseCase: WriteEpisodeUseCase {
    enum WriteEpisodeError: Error {
        case createStore
        case updateEpisode
        case saveEpisodeImage
    }
    
    private let writeEpisodeRepository: WriteEpisodeRepository
    private let writeEpisodeLocalRepository: WriteEpisodeLocalRepository
    
    init(
        writeEpisodeRepository: WriteEpisodeRepository,
        writeEpisodeLocalRepository: WriteEpisodeLocalRepository
    ) {
        self.writeEpisodeRepository = writeEpisodeRepository
        self.writeEpisodeLocalRepository = writeEpisodeLocalRepository
    }
    
    func updateEpisodeList(_ store: StoreVO, episode: EpisodeVO, imageData: Data) -> Completable {
        let episodeTable = episode.makeEpisodeTable()
        let exists = storeExists(store.id)
        
        // Realm write: 가게가 없으면 episode을 append한 새 StoreTable 생성, 있으면 기존 데이터에 episode 추가
        let realmWrite: Completable = exists
        ? writeEpisodeLocalRepository.updateEpisode(id: store.id, episode: episodeTable)
            .catch { _ in .error(WriteEpisodeError.updateEpisode) }
        : {
            let storeTable = store.makeStoreTable()
            storeTable.episode.append(episodeTable)
            return writeEpisodeLocalRepository.createStoreTable(storeTable)
                .catch { _ in .error(WriteEpisodeError.createStore) }
        }()
        
        let imageSave = writeEpisodeRepository
            .saveImage(fileName: "\(episodeTable._id).jpg", imageData: imageData)
            .catch { _ in .error(WriteEpisodeError.saveEpisodeImage) }
        
        return Completable.zip(realmWrite, imageSave)
    }
}

extension DefaultWriteEpisodeUseCase {
    private func storeExists(_ id: String) -> Bool {
        writeEpisodeLocalRepository.checkContainsStore(id)
    }
}

extension EpisodeVO {
    func makeEpisodeTable() -> EpisodeTable {
        let episodeTable = EpisodeTable(
            date: self.date,
            comment: self.comment,
            imageURL: self.imageURL,
            alcohol: self.alcohol,
            drink: self.drink,
            drinkQuantity: self.drinkQuantity
        )
        return episodeTable
    }
}
