//
//  LocationDetailUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

import RxSwift
import RxRelay

final class LocationDetailUseCase {
    
    private let disposebag = DisposeBag()
    
    var hashTag = PublishRelay<String>()
    var placeName = PublishRelay<String>()
    var distance = PublishRelay<String>()
    
    func fetchStoreDetail(store: StoreVO) {
        Observable.just(store)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .withUnretained(self)
            .subscribe(onNext: { owner, store in
                owner.hashTag.accept(store.categoryType.hashTag)
                owner.placeName.accept(store.placeName)
                owner.distance.accept(store.distance)
            })
            .disposed(by: disposebag)

    }
}
