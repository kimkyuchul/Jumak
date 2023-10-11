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
        let viewDidLoadEvent: Observable<Void>
        let didSelectWriteButton: Observable<Void>
        let didSelectDatePicker: Observable<Date>
    }
    
    struct Output {
        let updateStoreEpisode = PublishRelay<Void>()
        let placeName = PublishRelay<String>()
        let date = BehaviorRelay<Date>(value: Date())
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                output.placeName.accept(owner.storeVO.placeName)
            })
            .disposed(by: disposeBag)
        
        input.didSelectWriteButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                let episodeTable = EpisodeTable(date: "20231022", comment: "내생일", imageURL: "URL", alcohol: "원소주", mixedAlcohol: "막걸리", drink: 3.5)
                
                owner.writeEpisodeUseCase.updateEpisodeList(owner.storeVO, episode: episodeTable)
                output.updateStoreEpisode.accept(())
            })
            .disposed(by: disposeBag)
        
        input.didSelectDatePicker
            .bind(to: output.date)
            .disposed(by: disposeBag)
            
        
        return output
    }
}
