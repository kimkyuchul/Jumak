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
    
    var hashTag = PublishSubject<String>()
    var placeName = PublishSubject<String>()
    var distance = PublishSubject<String>()
    var type = PublishSubject<String>()
    var address = PublishSubject<String>()
    var roadAddress = PublishSubject<String>()
    var phone = PublishSubject<String>()
    var rate = PublishSubject<Int>()
    
    func fetchStoreDetail(store: StoreVO) {
        Observable.just(store)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .withUnretained(self)
            .subscribe(onNext: { owner, store in
                owner.hashTag.onNext(store.categoryType.hashTag)
                owner.placeName.onNext(store.placeName)
                owner.distance.onNext(store.distance)
                owner.type.onNext(store.categoryName)
                owner.address.onNext(store.addressName)
                owner.roadAddress.onNext(store.roadAddressName)
                owner.phone.onNext(store.phone ?? "")
                owner.rate.onNext(store.rate)
            })
            .disposed(by: disposebag)
    }
}
