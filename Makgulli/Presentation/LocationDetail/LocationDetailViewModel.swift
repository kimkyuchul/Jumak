//
//  LocationDetailViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import Foundation

import RxSwift
import RxRelay

final class LocationDetailViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
        
    var storeVO : StoreVO
    private let locationDetailUseCase: LocationDetailUseCase
    
    init(
        storeVO: StoreVO,
        locationDetailUseCase: LocationDetailUseCase
    ) {
        self.storeVO = storeVO
        self.locationDetailUseCase = locationDetailUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let didSelectRate: PublishSubject<Int>
        let didSelectBookmark: Observable<Bool>
    }
    
    struct Output {
        let hashTag = PublishRelay<String>()
        let placeName = PublishRelay<String>()
        let distance = PublishRelay<String>()
        let type = PublishRelay<String>()
        let address = PublishRelay<String>()
        let roadAddress = PublishRelay<String>()
        let phone = PublishRelay<String>()
        let rate =  PublishRelay<Int>()
        let convertRateLabelText = PublishRelay<Int>()
        let bookmark = PublishRelay<Bool>()
        let showBookmarkToast = PublishRelay<Bool>()
        let showErrorAlert = PublishRelay<Error>()
        
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { owner, _ in
                owner.locationDetailUseCase.fetchStoreDetail(store: owner.storeVO)
            })
            .disposed(by: disposeBag)
        
        input.viewWillDisappearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.locationDetailUseCase.handleLocalStore(owner.storeVO)
            })
            .disposed(by: disposeBag)
        
        let didSelectRate = input.didSelectRate
            .share()
        
        didSelectRate
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind(onNext: { owner, rate in
                owner.storeVO.rate = rate
            })
            .disposed(by: disposeBag)
        
        didSelectRate
            .bind(to: output.convertRateLabelText)
            .disposed(by: disposeBag)
        
        let didSelectBookmark = input.didSelectBookmark
            .share()
        
        didSelectBookmark
            .skip(1)
            .withUnretained(self)
            .bind(onNext: { owner, bookmark in
                owner.storeVO.bookmark = bookmark
            })
            .disposed(by: disposeBag)
        
        didSelectBookmark
            .bind(to: output.showBookmarkToast)
            .disposed(by: disposeBag)
                
        createOutput(output: output)
        
        return output
    }
    
    private func createOutput(output: Output) {
        locationDetailUseCase.hashTag
            .bind(to: output.hashTag)
            .disposed(by: disposeBag)
                
        locationDetailUseCase.placeName
            .bind(to: output.placeName)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.distance
            .bind(to: output.distance)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.type
            .bind(to: output.type)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.address
            .bind(to: output.address)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.roadAddress
            .bind(to: output.roadAddress)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.phone
            .bind(to: output.phone)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.rate
            .bind(to: output.rate)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.errorSubject
            .bind(to: output.showErrorAlert)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.bookmark
            .bind(to: output.bookmark)
            .disposed(by: disposeBag)
    }
}

