//
//  WriteEpisodeUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import Foundation

import RxSwift

protocol WriteEpisodeUseCase: AnyObject {
    func updateEpisodeList(_ store: StoreVO, episode: EpisodeTable)
    func saveEpisodeImage(fileName: String, imageData: Data)
    func updateValidation(text: String) -> Bool
    
    var errorSubject: PublishSubject<Error> { get set }
    var updateEpisodeListState: PublishSubject<Void> { get set }
    var saveEpisodeImageState: PublishSubject<Void> { get set }
}

final class DefaultWriteEpisodeUseCase: WriteEpisodeUseCase {
    
    enum WriteEpisodeError: Error {
        case createStore
        case updateEpisode
    }
    
    private let realmRepository: RealmRepository
    private let writeEpisodeRepository: WriteEpisodeRepository
    private let disposebag = DisposeBag()
    
    var errorSubject = PublishSubject<Error>()
    var updateEpisodeListState = PublishSubject<Void>()
    var saveEpisodeImageState = PublishSubject<Void>()
    
    
    init(realmRepository: RealmRepository,
         writeEpisodeRepository: WriteEpisodeRepository
    ) {
        self.realmRepository = realmRepository
        self.writeEpisodeRepository = writeEpisodeRepository
    }
    
    func updateEpisodeList(_ store: StoreVO, episode: EpisodeTable) {
        // 가게가 렘에 추가되지 않은 상태
        if !storeExists(store.id) {
            var updatedStoreVO = store
            updatedStoreVO.episode.append(episode.toDomain())
            
            // episode을 append하고 가게를 램에 추가
            createStore(updatedStoreVO)
            
        } else {
            // 가게가 렘에 추가되어 있는 상태라면 해당 데이터에 updateEpisode
            updateEpisode(store.id, episode)
        }
        
        updateEpisodeListState.onNext(Void())
    }
        
    func saveEpisodeImage(fileName: String, imageData: Data) {
        writeEpisodeRepository.saveImage(fileName: fileName, imageData: imageData)
            .subscribe { [weak self] completable in
                switch completable {
                case .completed:
                    self?.saveEpisodeImageState.onNext(Void())
                case .error(let error):
                    self?.errorSubject.onNext(error)
                }
            }
            .disposed(by: disposebag)
    }
    
    func updateValidation(text: String) -> Bool {
        guard !text.isEmpty else {
            return false
        }
        
        return true
    }
}

extension DefaultWriteEpisodeUseCase {
    private func createStore(_ store: StoreVO) {
        realmRepository.createStore(store)
            .subscribe(onCompleted: {
                dump("createStore")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(WriteEpisodeError.createStore)
            })
            .disposed(by: disposebag)
    }
    
    private func updateEpisode(_ id: String, _ episode: EpisodeTable) {
        realmRepository.updateEpisode(id: id, episode: episode)
            .subscribe(onCompleted: {
                dump("updateEpisode")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(WriteEpisodeError.updateEpisode)
            })
            .disposed(by: disposebag)
    }
    
    private func storeExists(_ id: String) -> Bool {
        return realmRepository.checkContainsStore(id: id)
    }
}
