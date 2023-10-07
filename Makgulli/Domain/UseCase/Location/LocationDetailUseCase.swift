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
    
    enum LocationDetailError: Error {
        case createBookmark
    }
    
    private let realmRepository: RealmRepository
    private let disposebag = DisposeBag()
    
    init(realmRepository: RealmRepository) {
        self.realmRepository = realmRepository
    }
    
    let hashTag = PublishSubject<String>()
    let placeName = PublishSubject<String>()
    let distance = PublishSubject<String>()
    let type = PublishSubject<String>()
    let address = PublishSubject<String>()
    let roadAddress = PublishSubject<String>()
    let phone = PublishSubject<String>()
    let rate = PublishSubject<Int>()
    
    let errorSubject = PublishSubject<Error>()
    
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
        
    func handleBookmark(_ store: StoreVO) {
        if store.bookmark && !storeExists(store.id) {
            createBookmark(store)
                .subscribe(onCompleted: {
                    dump("createBookmark")
                }, onError: { [weak self] error in
                    self?.errorSubject.onNext(LocationDetailError.createBookmark)
                })
                .disposed(by: disposebag)
        }
    }
}

extension LocationDetailUseCase {
    private func storeExists(_ id: String) -> Bool {
        return realmRepository.checkContainsStore(id: id)
    }
    
    private func createBookmark(_ store: StoreVO) -> Completable {
        return realmRepository.createBookmark(store)
    }
}
