//
//  WriteEpisodeViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import Foundation

import RxRelay
import RxSwift

final class WriteEpisodeViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    private let writeEpisodeUseCase: WriteEpisodeUseCase
    private var storeVO: StoreVO
    
    init(
        storeVO: StoreVO,
        writeEpisodeUseCase: WriteEpisodeUseCase
    ) {
        self.storeVO = storeVO
        self.writeEpisodeUseCase = writeEpisodeUseCase
    }
    
    struct Input {
        let didSelectWriteButton: Observable<Void>
    }
    
    struct Output {
        let updateStoreEpisode = PublishRelay<Void>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didSelectWriteButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                let episodeTable = EpisodeTable(date: "20231022", comment: "내생일", imageURL: "URL", alcohol: "원소주", mixedAlcohol: "막걸리", drink: 3.5)
                
                owner.writeEpisodeUseCase.updateEpisodeList(owner.storeVO, episode: episodeTable)
                output.updateStoreEpisode.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
