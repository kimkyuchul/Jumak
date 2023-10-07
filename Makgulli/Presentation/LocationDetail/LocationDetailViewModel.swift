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
        let viewDidDisappear: Observable<Void>
    }
    
    struct Output {
        let hashTag = PublishRelay<String>()
        let placeName = PublishRelay<String>()
        let distance = PublishRelay<String>()
        var type = PublishRelay<String>()
        var address = PublishRelay<String>()
        var roadAddress = PublishRelay<String>()
        var phone = PublishRelay<String>()
        var rate =  PublishRelay<Int>()
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
        
        input.viewDidDisappear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.locationDetailUseCase.setBookmarkStore(store: owner.storeVO)
            })
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
    }
    
}

