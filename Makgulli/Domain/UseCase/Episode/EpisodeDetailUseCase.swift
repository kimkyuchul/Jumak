//
//  WriteEpisodeDetailUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxSwift

final class EpisodeDetailUseCase {
    
    enum EpisodeDetailUseError: Error {
        case createStore
    }
    
    private let realmRepository: RealmRepository
    private let disposebag = DisposeBag()
    
    init(realmRepository: RealmRepository) {
        self.realmRepository = realmRepository
    }
    
    let episodeDiffableItem = PublishSubject<Episode>()
    
    let errorSubject = PublishSubject<Error>()
    
    func fetchEpisodeDetail(episode: Episode) {
        Observable.just(episode)
            .withUnretained(self)
            .subscribe(onNext: { owner, episode in
                owner.episodeDiffableItem.onNext(episode)
            })
            .disposed(by: disposebag)
    }
}
