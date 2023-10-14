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
    private let drinkCountSubject = BehaviorSubject<Double>(value: 1.0)
    private var imageData = Data()
    
    init(
        storeVO: StoreVO,
        writeEpisodeUseCase: WriteEpisodeUseCase
    ) {
        self.storeVO = storeVO
        self.writeEpisodeUseCase = writeEpisodeUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let didSelectDatePicker: Observable<Date>
        let commentTextFieldDidEditEvent: Observable<String>
        let didSelectImage: Observable<Bool>
        let episodeImageData: Observable<Data>
        let drinkNameTextFieldDidEditEvent: Observable<String>
        let didSelectDefaultDrinkCheckButton: Observable<Bool>
        let didSelectMinusDrinkCountButton: Observable<Void>
        let didSelectPlusDrinkCountButton: Observable<Void>
        let didSelectQuantity: Observable<QuantityType>
        let didSelectWriteButton: Observable<Void>
    }
    
    struct Output {
        let placeName = PublishRelay<String>()
        let date = BehaviorRelay<Date>(value: Date())
        let drinkCount = BehaviorRelay<Double>(value: 1.0)
        let quantity = BehaviorRelay<QuantityType>(value: .bottle)
        let isForgetDrinkName = PublishRelay<Bool>()
        let isCommentValid = PublishRelay<Bool>()
        let isDrinkNameValid = PublishRelay<Bool>()
        let isSelectImageValid = PublishRelay<Bool>()
        let writeButtonIsEnabled = BehaviorRelay<Bool>(value: false)
        let updateStoreEpisode = PublishRelay<Void>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        let isAllInputValid = Observable
            .combineLatest(
                output.isCommentValid,
                output.isDrinkNameValid,
                output.isSelectImageValid,
                resultSelector: {
                    $0 && $1 && $2
                }
            )
        
        input.viewDidLoadEvent
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                output.placeName.accept(owner.storeVO.placeName)
            })
            .disposed(by: disposeBag)
        
        input.didSelectDatePicker
            .bind(to: output.date)
            .disposed(by: disposeBag)
        
        input.commentTextFieldDidEditEvent
            .distinctUntilChanged()
            .withUnretained(self)
            .map { owner, comment in
                owner.writeEpisodeUseCase.updateValidation(text: comment)
            }
            .bind(onNext: { result in
                output.isCommentValid.accept(result)
            })
            .disposed(by: disposeBag)
        
        input.didSelectImage
            .skip(1)
            .bind(to: output.isSelectImageValid)
            .disposed(by: disposeBag)
        
        input.episodeImageData
            .withUnretained(self)
            .bind(onNext: { owner, imageData in
                owner.imageData = imageData
            })
            .disposed(by: disposeBag)
        
        input.drinkNameTextFieldDidEditEvent
            .distinctUntilChanged()
            .withUnretained(self)
            .map { owner, drinkName in
                owner.writeEpisodeUseCase.updateValidation(text: drinkName)
            }
            .bind(onNext: { result in
                output.isDrinkNameValid.accept(result)
            })
            .disposed(by: disposeBag)
        
        let didSelectDefaultDrinkCheckButton = input.didSelectDefaultDrinkCheckButton
            .share()
        
        didSelectDefaultDrinkCheckButton
            .bind(to: output.isDrinkNameValid)
            .disposed(by: disposeBag)
        
        didSelectDefaultDrinkCheckButton
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
        
        input.didSelectQuantity
            .bind(to: output.quantity)
            .disposed(by: disposeBag)
        
        isAllInputValid
            .bind(to: output.writeButtonIsEnabled)
            .disposed(by: disposeBag)
        
        input.didSelectWriteButton
            .withLatestFrom(transformUpdateEpisode(input: input, output: output))
            .withUnretained(self)
            .bind(onNext: { owner, episodeTable in
                owner.writeEpisodeUseCase.updateEpisodeList(owner.storeVO, episode: episodeTable)
                owner.writeEpisodeUseCase.saveEpisodeImage(fileName: "\(episodeTable).jpg", imageData: owner.imageData)
            })
            .disposed(by: disposeBag)
        
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        Observable.merge(writeEpisodeUseCase.updateEpisodeListState, writeEpisodeUseCase.saveEpisodeImageState)
            .bind(to: output.updateStoreEpisode)
            .disposed(by: disposeBag)
    }
}

extension WriteEpisodeViewModel {
    private func transformUpdateEpisode(input: WriteEpisodeViewModel.Input, output: WriteEpisodeViewModel.Output) -> Observable<EpisodeTable> {
        return Observable.combineLatest(output.date, input.commentTextFieldDidEditEvent, input.drinkNameTextFieldDidEditEvent, output.drinkCount, output.quantity)
            .map { date, comment, drinkName, drinkCount, drinkQuantity in
                return EpisodeTable(date: date,
                                    comment: comment,
                                    imageURL: "",
                                    alcohol: drinkName,
                                    drink: drinkCount,
                                    drinkQuantity: drinkQuantity)
            }
    }
}
