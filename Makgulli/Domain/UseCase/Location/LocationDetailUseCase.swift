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
        case createStore
        case updateStore
        case deleteStore
    }
    
    private let realmRepository: RealmRepository
    private let locationDetailRepository: LocationDetailRepository
    private let disposebag = DisposeBag()
    
    init(realmRepository: RealmRepository,
         locationDetailRepository: LocationDetailRepository
    ) {
        self.realmRepository = realmRepository
        self.locationDetailRepository = locationDetailRepository
    }
    
    let hashTag = PublishSubject<String>()
    let placeName = PublishSubject<String>()
    let distance = PublishSubject<String>()
    let type = PublishSubject<String>()
    let address = PublishSubject<String>()
    let roadAddress = PublishSubject<String>()
    let phone = PublishSubject<String>()
    let rate = PublishSubject<Int>()
    let bookmark =  PublishSubject<Bool>()
    let locationCoordinate = PublishSubject<(Double, Double)>()
    let episodeList = PublishSubject<[EpisodeVO]>()
        
    let errorSubject = PublishSubject<Error>()
    
    func fetchStoreDetail(store: StoreVO) {
        Observable.just(store)
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
                owner.bookmark.onNext(store.bookmark)
                owner.locationCoordinate.onNext((store.y, store.x))
                owner.episodeList.onNext(store.episode)
            })
            .disposed(by: disposebag)
    }
    
    func  handleLocalStore(_ store: StoreVO) {
        if !storeExists(store.id) && hasRatingOrEpisode(store) {
            // Realm에 존재하지 않으면서, 평점 또는 에피소드, 북마크 중 하나라도 존재하는 경우
            createBookmark(store)
            
        } else if storeExists(store.id) {
            // Realm에 존재하는 경우
            
            if hasRatingOrEpisode(store) {
                // 평점 또는 에피소드, 북마크 중 하나라도 존재하는 경우
                
                if shouldUpdateStore(store) {
                    // 변경된 사항이 존재할 경우
                    updateStoreBookmark(store)
                }
                
            } else {
                // Realm에 존재하는데, 평점, 에피소드, 북마크 모두 값이 없는 경우
                deleteStoreBookmark(store)
            }
        }
    }
    
    // 에피소드 추가뷰에서 에피소드를 추가하고 Dismiss됐을 때 에피소드를 업데이트
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO? {
        return realmRepository.updateStoreEpisode(store: store)
    }
    
    // 에피소드 콜렉션뷰의 셀 이미지를 load
    func loadDataSourceImage(_ fileName: String) -> Data? {
        locationDetailRepository.loadDataSourceImage(fileName: fileName)
    }
}

extension LocationDetailUseCase {
    private func createBookmark(_ store: StoreVO) {
        realmRepository.createStore(store)
            .subscribe(onCompleted: {
                dump("createBookmark")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(LocationDetailError.createStore)
            })
            .disposed(by: disposebag)
    }
    
    private func updateStoreBookmark(_ store: StoreVO) {
        realmRepository.updateStore(store)
            .subscribe(onCompleted: {
                dump("updateStoreBookmark")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(LocationDetailError.updateStore)
            })
            .disposed(by: disposebag)
    }
    
    private func deleteStoreBookmark(_ store: StoreVO) {
        realmRepository.deleteStore(store)
            .subscribe(onCompleted: {
                dump("deleteStoreBookmark")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(LocationDetailError.deleteStore)
            })
            .disposed(by: disposebag)
    }
    
    private func storeExists(_ id: String) -> Bool {
        return realmRepository.checkContainsStore(id: id)
    }
    
    private func shouldUpdateStore(_ store: StoreVO) -> Bool {
        return realmRepository.shouldUpdateStore(store)
    }
    
    private func hasRatingOrEpisode(_ store: StoreVO) -> Bool {
        return store.rate > 0 || !store.episode.isEmpty || store.bookmark
    }
}
