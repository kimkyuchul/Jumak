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
    private var defaultDrinkCount = 1.0
    private var drinkCountSubject = BehaviorSubject<Double>(value: 1.0)
    
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
        let didSelectImage: Observable<Bool>
        let didSelectDefaultDrinkCheckButton: Observable<Bool>
        let didSelectMinusDrinkCountButton: Observable<Void>
        let didSelectPlusDrinkCountButton: Observable<Void>
    }
    
    struct Output {
        let updateStoreEpisode = PublishRelay<Void>()
        let placeName = PublishRelay<String>()
        let date = BehaviorRelay<Date>(value: Date())
        let isForgetDrinkName = PublishRelay<Bool>()
        let drinkCount = BehaviorRelay<Double>(value: 1.0)
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
        
        input.didSelectImage
            .skip(1)
            .bind(onNext: { hasImage in
                print("hasImage", hasImage)
            })
            .disposed(by: disposeBag)
        
        input.didSelectDefaultDrinkCheckButton
            .bind(to: output.isForgetDrinkName)
            .disposed(by: disposeBag)
                
        input.didSelectMinusDrinkCountButton
            .map { 0.5 }
            .withUnretained(self)
            .bind(onNext: { owner, minusDrink in
                if owner.defaultDrinkCount > 0 {
                    owner.defaultDrinkCount -= minusDrink
                    owner.drinkCountSubject.onNext(owner.defaultDrinkCount)
                }
            })
            .disposed(by: disposeBag)
        
        input.didSelectPlusDrinkCountButton
            .map { 0.5 }
            .withUnretained(self)
            .bind(onNext: { owner, minusDrink in
                if owner.defaultDrinkCount < 100 {
                    owner.defaultDrinkCount += minusDrink
                    owner.drinkCountSubject.onNext(owner.defaultDrinkCount)
                }
            })
            .disposed(by: disposeBag)
        
        drinkCountSubject
            .bind(to: output.drinkCount)
            .disposed(by: disposeBag)
        
        return output
    }
}
