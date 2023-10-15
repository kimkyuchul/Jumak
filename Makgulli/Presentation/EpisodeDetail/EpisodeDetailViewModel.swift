//
//  EpisodeDetailViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxRelay
import RxSwift

final class EpisodeDetailViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    private let episodeDetailUseCase: EpisodeDetailUseCase
    private var episode: Episode
    var storedID: String
    
    init(
        episode: Episode,
        storedID: String,
        episodeDetailUseCase: EpisodeDetailUseCase
    ) {
        self.episode = episode
        self.storedID = storedID
        self.episodeDetailUseCase = episodeDetailUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let episode = PublishRelay<Episode>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                owner.episodeDetailUseCase.fetchEpisodeDetail(episode: owner.episode)
            })
            .disposed(by: disposeBag)
        
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        episodeDetailUseCase.episodeDiffableItem
            .bind(to: output.episode)
            .disposed(by: disposeBag)
    }
}