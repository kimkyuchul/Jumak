//
//  LocationDetailViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/05.
//

import Foundation

import RxSwift
import RxRelay

struct Episode: Hashable {
    let id: String
    let uuid: String = UUID().uuidString
    let date: Date
    let comment: String
    let alcohol: String
    let drink: Double
    let drinkQuantity: QuantityType
    let imageData: Data
}

final class LocationDetailViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    var storeVO: StoreVO
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
        let viewWillAppearEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let didSelectRate: Observable<Int>
        let didSelectBookmark: Observable<Bool>
        let didSelectUserLocationButton: Observable<Void>
        let didSelectCopyAddressButton : Observable<Void>
        let didSelectMakeEpisodeButton: Observable<Void>
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
        let addressPasteboardToast = PublishRelay<Void>()
        let locationCoordinate = PublishRelay<(Double, Double)>()
        let setCameraPosition = PublishRelay<(Double, Double)>()
        let showErrorAlert = PublishRelay<Error>()
        let presentWriteEpisode = PublishRelay<StoreVO>()
        let episodeList = PublishRelay<[EpisodeVO]>()
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
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let updatedStoreVO = owner.locationDetailUseCase.updateStoreEpisode(owner.storeVO)
                owner.storeVO.episode = updatedStoreVO?.episode ?? []
                output.episodeList.accept(owner.storeVO.episode)
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
                
                if bookmark {
                    owner.storeVO.bookmarkDate = Date()
                } else {
                    owner.storeVO.bookmarkDate = nil
                }
            })
            .disposed(by: disposeBag)
        
        didSelectBookmark
            .bind(to: output.showBookmarkToast)
            .disposed(by: disposeBag)
        
        input.didSelectUserLocationButton
            .withLatestFrom(output.locationCoordinate)
            .bind(to: output.setCameraPosition)
            .disposed(by: disposeBag)
        
        input.didSelectCopyAddressButton
            .withLatestFrom(output.address)
            .withUnretained(self)
            .flatMap { owner, adress in
                return owner.locationDetailUseCase.addressPasteboard(adress)
            }
            .bind(to: output.addressPasteboardToast)
            .disposed(by: disposeBag)
        
        input.didSelectMakeEpisodeButton
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                output.presentWriteEpisode.accept(owner.storeVO)
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
        
        locationDetailUseCase.errorSubject
            .bind(to: output.showErrorAlert)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.bookmark
            .bind(to: output.bookmark)
            .disposed(by: disposeBag)
        
        locationDetailUseCase.locationCoordinate
            .bind(to: output.locationCoordinate)
            .disposed(by: disposeBag)
                        
        locationDetailUseCase.episodeList
            .bind(to: output.episodeList)
            .disposed(by: disposeBag)
    }
}

extension LocationDetailViewModel {
    func loadDataSourceImage(_ fileName: String) -> Data? {
        locationDetailUseCase.loadDataSourceImage(fileName)
    }
}

