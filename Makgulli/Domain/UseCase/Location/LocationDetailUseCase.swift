//
//  LocationDetailUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

import RxSwift

protocol LocationDetailUseCase: AnyObject {
    func fetchStoreDetail(store: StoreVO)
    func handleLocalStore(_ store: StoreVO)
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO?
    func loadDataSourceImage(_ fileName: String) -> Data?
    func addressPasteboard(_ address: String) -> Observable<Void>
    func showMap(_ findRouteType: FindRouteType, locationCoordinate: (Double, Double), address: String)
    
    var hashTag: PublishSubject<String> { get }
    var placeName: PublishSubject<String> { get }
    var distance: PublishSubject<String> { get }
    var type: PublishSubject<String> { get }
    var address: PublishSubject<String> { get }
    var roadAddress: PublishSubject<String> { get }
    var phone: PublishSubject<String> { get }
    var rate: PublishSubject<Int> { get }
    var bookmark:  PublishSubject<Bool> { get }
    var locationCoordinate: PublishSubject<(Double, Double)> { get }
    var episodeList: PublishSubject<[EpisodeVO]> { get }
    var errorSubject: PublishSubject<Error> { get }
    
}

final class DefaultLocationDetailUseCase: LocationDetailUseCase {
    
    enum LocationDetailError: Error {
        case createStore
        case updateStore
        case deleteStore
    }
    
    private let locationDetailRepository: LocationDetailRepository
    private let locationDetailLocalRepository: LocationDetailLocalRepository
    private let urlSchemaService: URLSchemaService
    private let pasteboardService: PasteboardService
    private let disposebag = DisposeBag()
    
    init(locationDetailRepository: LocationDetailRepository,
         locationDetailLocalRepository: LocationDetailLocalRepository,
         urlSchemaService: URLSchemaService,
         pasteboardService: PasteboardService
    ) {
        self.locationDetailRepository = locationDetailRepository
        self.urlSchemaService = urlSchemaService
        self.pasteboardService = pasteboardService
        self.locationDetailLocalRepository = locationDetailLocalRepository
    }
    
    var hashTag = PublishSubject<String>()
    var placeName = PublishSubject<String>()
    var distance = PublishSubject<String>()
    var type = PublishSubject<String>()
    var address = PublishSubject<String>()
    var roadAddress = PublishSubject<String>()
    var phone = PublishSubject<String>()
    var rate = PublishSubject<Int>()
    var bookmark =  PublishSubject<Bool>()
    var locationCoordinate = PublishSubject<(Double, Double)>()
    var episodeList = PublishSubject<[EpisodeVO]>()
        
    var errorSubject = PublishSubject<Error>()
    
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
    
    func handleLocalStore(_ store: StoreVO) {
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
        return locationDetailLocalRepository.updateStoreEpisode(store)
    }
    
    // 에피소드 콜렉션뷰의 셀 이미지를 load
    func loadDataSourceImage(_ fileName: String) -> Data? {
        locationDetailRepository.loadDataSourceImage(fileName: fileName)
    }
    
    func addressPasteboard(_ address: String) -> Observable<Void> {
        return Observable.create { [weak self] emitter in
            self?.pasteboardService.addressPasteboard(address: address)
            emitter.onNext(Void())
            emitter.onCompleted()
            return Disposables.create()
        }
    }
    
    func showMap(_ findRouteType: FindRouteType, locationCoordinate: (Double, Double), address: String) {
        urlSchemaService.openMapForURL(findRouteType: findRouteType, locationCoordinate: locationCoordinate, address: address)
        }
}

extension DefaultLocationDetailUseCase {
    private func createBookmark(_ store: StoreVO) {
        locationDetailLocalRepository.createStore(store)
            .subscribe(onCompleted: {
                dump("createBookmark")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(LocationDetailError.createStore)
            })
            .disposed(by: disposebag)
    }
    
    private func updateStoreBookmark(_ store: StoreVO) {
        locationDetailLocalRepository.updateStore(store)
            .subscribe(onCompleted: {
                dump("updateStoreBookmark")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(LocationDetailError.updateStore)
            })
            .disposed(by: disposebag)
    }
    
    private func deleteStoreBookmark(_ store: StoreVO) {
        locationDetailLocalRepository.deleteStore(store)
            .subscribe(onCompleted: {
                dump("deleteStoreBookmark")
            }, onError: { [weak self] error in
                self?.errorSubject.onNext(LocationDetailError.deleteStore)
            })
            .disposed(by: disposebag)
    }
    
    private func storeExists(_ id: String) -> Bool {
        return locationDetailLocalRepository.checkContainsStore(id)
    }
    
    private func shouldUpdateStore(_ store: StoreVO) -> Bool {
        return locationDetailLocalRepository.shouldUpdateStore(store)
    }
    
    private func hasRatingOrEpisode(_ store: StoreVO) -> Bool {
        return store.rate > 0 || !store.episode.isEmpty || store.bookmark
    }
}
