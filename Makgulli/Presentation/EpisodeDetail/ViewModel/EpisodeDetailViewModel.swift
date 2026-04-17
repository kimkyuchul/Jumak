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

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let didSelectBackButton: Observable<Void>
        let didSelectDeleteButton: Observable<Void>
    }

    struct Output {
        let episode = PublishRelay<Episode>()
        let showErrorAlert = PublishRelay<Error>()
    }

    func transform(input: Input) -> Output {
        let output = Output()

        input.viewDidLoadEvent
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                output.episode.accept(owner.episode)
            }
            .disposed(by: disposeBag)

        input.didSelectBackButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.popEpisodeDetail()
            }
            .disposed(by: disposeBag)

        input.didSelectDeleteButton
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.episodeDetailUseCase
                    .deleteEpisode(
                        storeId: owner.storeId,
                        episodeId: owner.episode.id,
                        imageFileName: "\(owner.episode.id).jpg".trimmingWhitespace()
                    )
                    .andThen(Observable.just(()))
                    .catch { error in
                        output.showErrorAlert.accept(error)
                        return .empty()
                    }
            }
            .bind(with: self) { owner, _ in
                owner.coordinator?.popEpisodeDetail()
            }
            .disposed(by: disposeBag)

        return output
    }
}
