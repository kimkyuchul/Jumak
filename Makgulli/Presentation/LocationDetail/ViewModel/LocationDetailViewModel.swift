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

final class LocationDetailViewModel: ViewModelType, Coordinatable {
    weak var coordinator: LocationDetailCoordinator?
    var disposeBag: DisposeBag = .init()

    var storeVO: StoreVO
    private let locationDetailUseCase: LocationDetailUseCase
    private let urlSchemaService: URLSchemaService
    private let pasteboardService: PasteboardService

    init(
        storeVO: StoreVO,
        locationDetailUseCase: LocationDetailUseCase,
        urlSchemaService: URLSchemaService,
        pasteboardService: PasteboardService
    ) {
        self.storeVO = storeVO
        self.locationDetailUseCase = locationDetailUseCase
        self.urlSchemaService = urlSchemaService
        self.pasteboardService = pasteboardService
    }

    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let viewWillAppearEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let didSelectBackButton: Observable<Void>
        let didSelectRate: Observable<Int>
        let didSelectBookmark: Observable<Bool>
        let didSelectFindRouteType: Observable<FindRouteType>
        let didSelectUserLocationButton: Observable<Void>
        let didSelectCopyAddressButton : Observable<Void>
        let didSelectMakeEpisodeButton: Observable<Void>
        let didSelectEpisodeItem: Observable<Episode>
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
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                let store = owner.storeVO
                output.hashTag.accept(store.categoryType.hashTag)
                output.placeName.accept(store.placeName)
                output.distance.accept(store.distance)
                output.type.accept(store.categoryName)
                output.address.accept(store.addressName)
                output.roadAddress.accept(store.roadAddressName)
                output.phone.accept(store.phone ?? "")
                output.rate.accept(store.rate)
                output.bookmark.accept(store.bookmark)
                output.locationCoordinate.accept((store.y, store.x))
                output.episodeList.accept(store.episode)
            }
            .disposed(by: disposeBag)

        input.viewWillAppearEvent
            .bind(with: self) { owner, _ in
                let updated = owner.locationDetailUseCase.updateStoreEpisode(owner.storeVO)
                owner.storeVO.episode = updated?.episode ?? []
                output.episodeList.accept(owner.storeVO.episode)
            }
            .disposed(by: disposeBag)

        input.viewWillDisappearEvent
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Event<Never>> in
                owner.locationDetailUseCase
                    .syncStore(owner.storeVO)
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { event in
                if case .error(let error) = event {
                    output.showErrorAlert.accept(error)
                }
            })
            .disposed(by: disposeBag)

        input.didSelectBackButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.popLocationDetail()
            }
            .disposed(by: disposeBag)

        let didSelectRate = input.didSelectRate
            .share()

        didSelectRate
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, rate in
                owner.storeVO.rate = rate
            }
            .disposed(by: disposeBag)

        didSelectRate
            .bind(to: output.convertRateLabelText)
            .disposed(by: disposeBag)

        let didSelectBookmark = input.didSelectBookmark
            .share()

        didSelectBookmark
            .skip(1)
            .bind(with: self) { owner, bookmark in
                owner.storeVO.bookmark = bookmark
                owner.storeVO.bookmarkDate = bookmark ? Date() : nil
            }
            .disposed(by: disposeBag)

        didSelectBookmark
            .bind(to: output.showBookmarkToast)
            .disposed(by: disposeBag)

        let addressAndCoordinate = Observable.zip(output.address, output.locationCoordinate)

        input.didSelectFindRouteType
            .withLatestFrom(addressAndCoordinate) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let (findRouteType, (address, coordinate)) = tuple
                owner.urlSchemaService.openMapForURL(
                    findRouteType: findRouteType,
                    locationCoordinate: coordinate,
                    address: address
                )
            }
            .disposed(by: disposeBag)

        input.didSelectUserLocationButton
            .withLatestFrom(output.locationCoordinate)
            .bind(to: output.setCameraPosition)
            .disposed(by: disposeBag)

        input.didSelectCopyAddressButton
            .withLatestFrom(output.address)
            .bind(with: self) { owner, address in
                owner.pasteboardService.addressPasteboard(address: address)
                output.addressPasteboardToast.accept(())
            }
            .disposed(by: disposeBag)

        input.didSelectMakeEpisodeButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.startWriteEpisode(store: owner.storeVO)
            }
            .disposed(by: disposeBag)

        input.didSelectEpisodeItem
            .bind(with: self) { owner, episode in
                owner.coordinator?.startEpisodeDetail(episode: episode, storeId: owner.storeVO.id)
            }
            .disposed(by: disposeBag)

        return output
    }
}

extension LocationDetailViewModel {
    func loadEpisodeImage(_ fileName: String) -> Data? {
        locationDetailUseCase.loadEpisodeImage(fileName)
    }
}
