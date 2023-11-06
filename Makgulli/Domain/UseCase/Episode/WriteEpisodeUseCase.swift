//
//  WriteEpisodeUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import Foundation

import RxSwift

protocol WriteEpisodeUseCase: AnyObject {
    func updateEpisodeList(_ store: StoreVO, episode: EpisodeVO, imageData: Data)
    func updateValidation(text: String) -> Bool
    
    var updateEpisodeListState: PublishSubject<Void> { get set }
    var saveEpisodeImageState: PublishSubject<Void> { get set }
    var errorSubject: PublishSubject<Error> { get set }
}

final class DefaultWriteEpisodeUseCase: WriteEpisodeUseCase {
    
    enum WriteEpisodeError: Error {
        case createStore
        case updateEpisode
        case saveEpisodeImage
    }
    
    private let realmRepository: RealmRepository
    private let writeEpisodeRepository: WriteEpisodeRepository
    private let writeEpisodeLocalRepository: WriteEpisodeLocalRepository
    private let disposebag = DisposeBag()
    
    var updateEpisodeListState = PublishSubject<Void>()
    var saveEpisodeImageState = PublishSubject<Void>()
    var errorSubject = PublishSubject<Error>()
    
    
    init(realmRepository: RealmRepository,
         writeEpisodeRepository: WriteEpisodeRepository,
         writeEpisodeLocalRepository: WriteEpisodeLocalRepository
    ) {
        self.realmRepository = realmRepository
        self.writeEpisodeRepository = writeEpisodeRepository
        self.writeEpisodeLocalRepository = writeEpisodeLocalRepository
    }
    
    func updateEpisodeList(_ store: StoreVO, episode: EpisodeVO, imageData: Data) {
        let updateEpisodeTable = episode.makeEpisodeTable()
        
        // 가게가 렘에 추가되지 않은 상태
        if !storeExists(store.id) {
            let updatedStoreTable = store.makeStoreTable()
            updatedStoreTable.episode.append(updateEpisodeTable)
            
            // episode을 append하고 가게를 램에 추가
            createStoreTable(updatedStoreTable)
            saveEpisodeImage(fileName: "\(updateEpisodeTable._id).jpg", imageData: imageData)
            
        } else {
            // 가게가 렘에 추가되어 있는 상태라면 해당 데이터에 updateEpisode
            updateEpisode(store.id, updateEpisodeTable)
            saveEpisodeImage(fileName: "\(updateEpisodeTable._id).jpg", imageData: imageData)
        }
        
        updateEpisodeListState.onNext(Void())
    }
            
    func updateValidation(text: String) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        return true
    }
}

extension DefaultWriteEpisodeUseCase {
    private func saveEpisodeImage(fileName: String, imageData: Data) {
        writeEpisodeRepository.saveImage(fileName: fileName, imageData: imageData)
            .subscribe { [weak self] completable in
                switch completable {
                case .completed:
                    self?.saveEpisodeImageState.onNext(Void())
                case .error(let error):
                    dump(error)
                    self?.errorSubject.onNext(WriteEpisodeError.saveEpisodeImage)
                }
            }
            .disposed(by: disposebag)
    }
    
    private func createStore(_ store: StoreVO) {
        writeEpisodeLocalRepository.createStore(store)
            .subscribe(onCompleted: {
                dump("createStore")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(WriteEpisodeError.createStore)
            })
            .disposed(by: disposebag)
    }
    
    private func createStoreTable(_ store: StoreTable) {
        writeEpisodeLocalRepository.createStoreTable(store)
            .subscribe(onCompleted: {
                dump("createStoreTable")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(WriteEpisodeError.createStore)
            })
            .disposed(by: disposebag)
    }
    
    private func updateEpisode(_ id: String, _ episode: EpisodeTable) {
        writeEpisodeLocalRepository.updateEpisode(id: id, episode: episode)
            .subscribe(onCompleted: {
                dump("updateEpisode")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(WriteEpisodeError.updateEpisode)
            })
            .disposed(by: disposebag)
    }
    
    private func storeExists(_ id: String) -> Bool {
        writeEpisodeLocalRepository.checkContainsStore(id)
    }
}
