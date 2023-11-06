//
//  LocationDetailViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/02.
//

import UIKit

import RxCocoa
import RxSwift

final class LocationDetailViewController: BaseViewController {
    
    private let locationDetailView = LocationDetailView()
    private let viewModel: LocationDetailViewModel
    private let didSelectFindRouteType = PublishRelay<FindRouteType>()
    
    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = locationDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "상세 정보"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
        
    override func bind() {
        let input = LocationDetailViewModel
            .Input(viewDidLoadEvent: Observable.just(()).asObservable(),
                   viewWillAppearEvent: self.rx.viewWillAppear.map { _ in },
                   viewWillDisappearEvent: self.rx.viewWillDisappear.map { _ in },
                   didSelectRate: locationDetailView.rateView.currentStarSubject.asObserver(),
                   didSelectBookmark: locationDetailView.titleView.bookMarkButton.rx.isSelected.asObservable(),
                   didSelectFindRouteType: didSelectFindRouteType.asObservable(),
                   didSelectUserLocationButton: locationDetailView.storeLocationButton.rx.tap.asObservable().throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
                   didSelectCopyAddressButton: locationDetailView.infoView.rx.tapCopyAddress.asObservable().throttle(.milliseconds(300), scheduler: MainScheduler.instance),
                   didSelectMakeEpisodeButton: locationDetailView.bottomView.rx.tapMakeEpisode.asObservable().throttle(.milliseconds(300), scheduler: MainScheduler.instance))
        let output = viewModel.transform(input: input)
        
        output.hashTag
            .bind(to: locationDetailView.titleView.rx.hashTag)
            .disposed(by: disposeBag)
        
        output.placeName
            .bind(to: locationDetailView.titleView.rx.placeName)
            .disposed(by: disposeBag)
        
        output.distance
            .bind(to: locationDetailView.titleView.rx.distance)
            .disposed(by: disposeBag)
        
        output.type
            .bind(to: locationDetailView.infoView.rx.type)
            .disposed(by: disposeBag)
        
        output.address
            .bind(to: locationDetailView.infoView.rx.address)
            .disposed(by: disposeBag)
        
        output.roadAddress
            .bind(to: locationDetailView.infoView.rx.roadAddress)
            .disposed(by: disposeBag)
        
        output.phone
            .bind(to: locationDetailView.infoView.rx.phone)
            .disposed(by: disposeBag)
        
        output.rate
            .withUnretained(self)
            .bind(onNext: { owner, rate in
                owner.locationDetailView.rateView.currentStar = rate
            })
            .disposed(by: disposeBag)
        
        output.convertRateLabelText
            .bind(to: locationDetailView.rateView.rx.rate)
            .disposed(by: disposeBag)
        
        output.bookmark
            .bind(to: locationDetailView.titleView.bookMarkButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.showBookmarkToast
            .withUnretained(self)
            .bind(onNext: {owner, bookmark in
                if bookmark {
                    owner.showToast(message: "즐겨찾기가 추가 되었습니다.")
                } else {
                    owner.showToast(message: "즐겨찾기가 삭제 되었습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.addressPasteboardToast
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.showToast(message: "주소가 복사되었습니다.")
            })
            .disposed(by: disposeBag)
        
        output.locationCoordinate
            .bind(to: locationDetailView.rx.setUpMarker)
            .disposed(by: disposeBag)
        
        output.setCameraPosition
            .bind(to: locationDetailView.rx.storeCameraPosition)
            .disposed(by: disposeBag)
        
        output.showErrorAlert
            .withUnretained(self)
            .flatMap { owner, error in
                dump(error)
                return owner.rx.makeErrorAlert(title: "네트워크 에러", message: "네트워크 에러가 발생했습니다.", cancelButtonTitle: "확인")
            }
            .subscribe()
            .disposed(by: disposeBag)
            
        output.presentWriteEpisode
            .withUnretained(self)
            .bind(onNext: { owner, storeVO in
                let writeEpisodeViewController = WriteEpisodeViewController(
                    viewModel: AppDIContainer.shared
                       .makeEpisodeDIContainer()
                       .makeLocationViewModel(store: storeVO)
                )
                
                writeEpisodeViewController.modalPresentationStyle = .fullScreen
                owner.present(writeEpisodeViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        let episodeList = output.episodeList
            .share()
            .distinctUntilChanged()
        
        episodeList
            .withUnretained(self)
            .map { owner, episodeList in
                let episodes = episodeList.map { episodeVO -> Episode in
                    return Episode(id: episodeVO.id,
                                   date: episodeVO.date,
                                   comment: episodeVO.comment,
                                   alcohol: episodeVO.alcohol,
                                   drink: episodeVO.drink,
                                   drinkQuantity: episodeVO.drinkQuantity,
                                   imageData: owner.viewModel.loadDataSourceImage("\(episodeVO.id).jpg".trimmingWhitespace()) ?? Data())
                }
                return episodes
            }
            .withUnretained(self)
            .bind(onNext: { owner, episodeList in
                owner.locationDetailView.applyCollectionViewDataSource(by: episodeList)
            })
            .disposed(by: disposeBag)
        
        episodeList
            .map { !$0.isEmpty }
            .bind(to: locationDetailView.episodeView.rx.handleEpisodeEmptyViewVisibility)
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        locationDetailView.titleView.rx.tapFindRoute
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.findRouteActionSheet()
            })
            .disposed(by: disposeBag)
        
        locationDetailView.rx.selectedItem
            .withUnretained(self)
             .subscribe(onNext: { owner, indexPath in
                 guard let episode = owner.locationDetailView.itemIdentifier(for: indexPath) else { return }
                 let episodeDetailViewController = EpisodeDetailViewController(viewModel: AppDIContainer.shared.makeEpisodeDIContainer().makeLocationViewModel(episode: episode, storeId: owner.viewModel.storeVO.id))
                 owner.navigationController?.pushViewController(episodeDetailViewController, animated: true)
             })
             .disposed(by: disposeBag)

        locationDetailView.bottomView.rx.tapWarning
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.presentAlert(type: .declarationStore, rightButtonAction:  { [weak owner] in
                    owner?.showToast(message: "정보가 접수되었습니다.")
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func findRouteActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
         for findRoute in FindRouteType.allCases {
             let alertAction = UIAlertAction(title: findRoute.title, style: .default) { [weak self] _ in
                 self?.didSelectFindRouteType.accept(findRoute)
             }
             alert.addAction(alertAction)
         }
         let cancel = UIAlertAction(title: "취소", style: .cancel)
         alert.addAction(cancel)
         present(alert, animated: true)
     }
}
