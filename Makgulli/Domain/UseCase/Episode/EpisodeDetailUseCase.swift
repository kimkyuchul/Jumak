//
//  WriteEpisodeDetailUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxSwift

protocol EpisodeDetailUseCase: AnyObject {
    func fetchEpisodeDetail(episode: Episode)
    func deleteEpisode(storeId: String, episodeId: String)
    func deleteEpisodeImage(fileName: String)
    
    var episodeDiffableItem: PublishSubject<Episode> { get }
    var deleteEpisodeState: PublishSubject<Void> { get }
    var deleteEpisodeImageState: PublishSubject<Void> { get }
    var errorSubject: PublishSubject<Error> { get }
}

final class DefaultEpisodeDetailUseCase: EpisodeDetailUseCase {
    
    enum EpisodeDetailUseError: Error {
        case deleteEpisode
        case deleteEpisodeImage
    }
    
    private let realmRepository: RealmRepository
    private let episodeDetailRepository: EpisodeDetailRepository
    private let disposebag = DisposeBag()
    
    init(realmRepository: RealmRepository,
         episodeDetailRepository: EpisodeDetailRepository
    ) {
        self.realmRepository = realmRepository
        self.episodeDetailRepository = episodeDetailRepository
    }
    
    var episodeDiffableItem = PublishSubject<Episode>()
    var deleteEpisodeState = PublishSubject<Void>()
    var deleteEpisodeImageState = PublishSubject<Void>()
    var errorSubject = PublishSubject<Error>()
    
    func fetchEpisodeDetail(episode: Episode) {
        Observable.just(episode)
            .withUnretained(self)
            .subscribe(onNext: { owner, episode in
                owner.episodeDiffableItem.onNext(episode)
            })
            .disposed(by: disposebag)
    }
    
    func deleteEpisode(storeId: String, episodeId: String) {
        realmRepository.deleteEpisode(id: storeId, episodeId: episodeId)
            .subscribe { [weak self] completable in
                switch completable {
                case .completed:
                    self?.deleteEpisodeState.onNext(Void())
                case .error(let error):
                    dump(error)
                    self?.errorSubject.onNext(EpisodeDetailUseError.deleteEpisode)
                }
            }
            .disposed(by: disposebag)
    }
    
    func deleteEpisodeImage(fileName: String) {
        episodeDetailRepository.removeImage(fileName: fileName)
            .subscribe { [weak self] completable in
                switch completable {
                case .completed:
                    self?.deleteEpisodeImageState.onNext(Void())
                case .error(let error):
                    dump(error)
                    self?.errorSubject.onNext(EpisodeDetailUseError.deleteEpisodeImage)
                }
            }
            .disposed(by: disposebag)
    }
}
