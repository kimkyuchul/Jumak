//
//  EpisodeDetailViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import Foundation

import RxRelay
import RxSwift

final class EpisodeDetailViewModel: ViewModelType, Coordinatable {
    weak var coordinator: EpisodeDetailCoordinator?
    var disposeBag: DisposeBag = .init()
    
    private let episodeDetailUseCase: EpisodeDetailUseCase
    private var episode: Episode
    private var storeId: String
    
    init(
        episode: Episode,
        storeId: String,
        episodeDetailUseCase: EpisodeDetailUseCase
    ) {
        self.episode = episode
        self.storeId = storeId
        self.episodeDetailUseCase = episodeDetailUseCase
    }
    
    deinit {
        coordinator?.didFinish()
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let didSelectBackButton: Observable<Void>
        let didSelectDeleteButton: Observable<Void>
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
                
        input.didSelectBackButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.popEpisodeDetail()
            }
            .disposed(by: disposeBag)
        
        input.didSelectDeleteButton
            .bind(with: self) { owner, _ in
                owner.episodeDetailUseCase.deleteEpisodeImage(fileName: "\(owner.episode.id).jpg".trimmingWhitespace())
                owner.episodeDetailUseCase.deleteEpisode(storeId: owner.storeId, episodeId: owner.episode.id)
            }
            .disposed(by: disposeBag)
 
        
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        episodeDetailUseCase.episodeDiffableItem
            .bind(to: output.episode)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(episodeDetailUseCase.deleteEpisodeState, episodeDetailUseCase.deleteEpisodeImageState)
            .map { _, _ in () }
            .bind(with: self) { owner, _ in
                owner.coordinator?.popEpisodeDetail()
            }
            .disposed(by: disposeBag)
    }
}
