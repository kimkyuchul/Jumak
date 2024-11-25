//
//  LocationViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit

import RxSwift
import RxCocoa
import NMapsMap

final class LocationViewController: BaseViewController {
    
    private let locationView = LocationView()
    
    private let viewModel: LocationViewModel
    private var markers: [NMFMarker] = []
    private var selectCategoryType: CategoryType = .makgulli
    private var selectMarkerRelay = PublishRelay<Int?>()
    private var changeMapLocation = PublishRelay<CLLocationCoordinate2D>()
    private let didSelectStoreItem = PublishRelay<StoreVO>()
    
    init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = locationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationView.mapView.addCameraDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind() {
        let input = LocationViewModel
            .Input(viewDidLoadEvent: Observable.just(()).asObservable(),
                   viewWillAppearEvent: self.rx.viewWillAppear.map { _ in }, 
                   didSelectQuestionButton:  locationView.questionButton.rx.tap.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance),
                   willDisplayCell: locationView.storeCollectionView.rx.willDisplayCell.map { $0.at },
                   didSelectMarker: selectMarkerRelay.asObservable(),
                   didSelectCategoryCell: locationView.categoryCollectionView.rx.itemSelected.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance),
                   changeMapLocation: changeMapLocation.asObservable(),
                   didSelectRefreshButton: locationView.researchButton.rx.tap.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance),
                   didSelectUserLocationButton: locationView.userLocationButton.rx.tap.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance),
                   didScrollStoreCollectionView: locationView.visibleItemsRelay.asObservable().debounce(.milliseconds(250), scheduler: MainScheduler.instance),
                   didSelectStoreItem: didSelectStoreItem.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance)
            )
        let output = viewModel.transform(input: input)
        
        output.storeList
            .distinctUntilChanged()
            .withLatestFrom(output.selectedMarkerIndex) { storeList, selectedMarkerIndex in
                return (storeList, selectedMarkerIndex)
            }
            .withUnretained(self)
            .bind(onNext: { owner, data in
                let (storeList, selectedMarkerIndex) = data
                owner.setUpMarker(selectedIndex: selectedMarkerIndex ?? 0, storeList: storeList)
                owner.locationView.storeCollectionView.selectItem(at: IndexPath(row: selectedMarkerIndex ?? 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
        
        output.selectedMarkerIndex
            .distinctUntilChanged()
            .withLatestFrom(output.storeList) { index, storeList in
                return (index, storeList)
            }
            .withUnretained(self)
            .bind(onNext: { owner, markerData in
                guard markerData.0 ?? 0 < markerData.1.count else { return }
                owner.setUpMarker(selectedIndex: markerData.0, storeList: markerData.1)
                owner.locationView.storeCollectionView.selectItem(at: IndexPath(row: markerData.0 ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
        
        output.setCameraPosition
            .asDriver(onErrorJustReturn: (LocationLiteral.longitude, LocationLiteral.latitude))
            .distinctUntilChanged { (prevPosition, newPosition) -> Bool in
                return prevPosition == newPosition
            }
            .drive(locationView.rx.cameraPosition)
            .disposed(by: disposeBag)
        
        output.currentUserLocation
            .bind(with: self) { owner, location in
                owner.updateUserCurrentLocation(latitude: location.latitude, longitude: location.longitude)
            }
            .disposed(by: disposeBag)
        
        output.currentUserAddress
            .bind(to: locationView.userAddressButton.rx.addressTitle)
            .disposed(by: disposeBag)
        
        output.authorizationAlertShouldShow
            .bind(with: self) { owner, authorization in
                if authorization {
                    owner.setRequestLocationServiceAlertAction()
                }
            }
            .disposed(by: disposeBag)
        
        output.reSearchButtonHidden
            .bind(to: locationView.rx.handleResearchButtonVisibility)
            .disposed(by: disposeBag)
        
        Observable.just(CategoryType.allCases)
            .bind(to: locationView.categoryCollectionView.rx.items(cellIdentifier: "CategoryCollectionViewCell", cellType: CategoryCollectionViewCell.self)) {
                index, item, cell in
                
                cell.configureCell(item: item)
                
                if item == self.selectCategoryType {
                    self.locationView.categoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.categoryType
            .bind(with: self) { owner, type in
                owner.selectCategoryType = type
            }
            .disposed(by: disposeBag)
        
        output.storeCollectionViewDataSource
            .bind(to: locationView.storeCollectionView.rx.items(cellIdentifier: "StoreCollectionViewCell", cellType: StoreCollectionViewCell.self)) { [weak self]
                index, item, cell in
                
                if let updatedItem = self?.viewModel.updateStoreCell(item) {
                    cell.configureCell(item: updatedItem)
                }
            }
            .disposed(by: disposeBag)
        
        output.storeEmptyViewHidden
            .bind(to: locationView.rx.handleStoreEmptyViewVisibility)
            .disposed(by: disposeBag)
        
        output.showErrorAlert
            .withUnretained(self)
            .flatMap { owner, error in
                return owner.rx.makeErrorAlert(title: "네트워크 에러", message: "네트워크 에러가 발생했습니다.", cancelButtonTitle: "확인")
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        output.isLoding
            .bind(to: locationView.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        Observable.zip(locationView.storeCollectionView.rx.modelSelected(StoreVO.self), locationView.storeCollectionView.rx.itemSelected)
            .withUnretained(self)
            .bind(onNext: { [weak self] data in
                if let updatedItem = self?.viewModel.updateStoreCell(data.1.0) {
                    data.0.didSelectStoreItem.accept(updatedItem)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func bindReachability() {
        super.bindReachability()
        
        let isReachable = reachability?.rx.isReachable
            .share()
            .distinctUntilChanged()
        
        isReachable?
            .bind(to: locationView.rx.handleNetworkErrorViewVisibility)
            .disposed(by: disposeBag)
        
        isReachable?
            .withUnretained(self)
            .bind(onNext:{ owner, isReachable in
                if !isReachable {
                    owner.clearMarker()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUserCurrentLocation(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) {
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: latitude,lng: longitude),
            zoom: locationView.mapView.zoomLevel
        )
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        cameraUpdate.animation = .easeIn
        locationView.mapView.moveCamera(cameraUpdate)
        
        guard let locationOverlay = locationView.locationOverlay else { return }
        locationOverlay.hidden = false
        locationOverlay.location = NMGLatLng(lat: latitude, lng: longitude)
        locationOverlay.icon = NMFOverlayImage(name: "imgLocationDirection", in: Bundle.naverMapFramework())
    }
    
    private func setUpMarker(selectedIndex: Int? = nil, storeList: [StoreVO]) {
        self.clearMarker()
        
        for (index, store) in storeList.enumerated() {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: store.y, lng: store.x)
            
            if index == selectedIndex {
                marker.iconImage = NMFOverlayImage(image: ImageLiteral.touchMarker)
                marker.width = DesignLiteral.touchMarkerWidth
                marker.height = DesignLiteral.touchMarkerheight
            } else {
                marker.iconImage = NMFOverlayImage(image: ImageLiteral.marker)
                marker.width = DesignLiteral.marker
                marker.height = DesignLiteral.marker
            }
            
            marker.mapView = self.locationView.mapView
            marker.touchHandler = { [weak self] _ in
                self?.selectMarkerRelay.accept(index)
                return true
            }
            self.markers.append(marker)
        }
    }
    
    private func clearMarker() {
        for marker in self.markers {
            marker.mapView = nil
        }
        self.markers.removeAll()
    }
    
    private func setRequestLocationServiceAlertAction() {
        let authAlertController: UIAlertController
        authAlertController = UIAlertController(
            title: "위치정보 권한 요청",
            message: "막걸리를 찾기 위해선 위치정보 권한이 필요해요!",
            preferredStyle: .alert
        )
        
        let getAuthAction: UIAlertAction
        getAuthAction = UIAlertAction(
            title: "설정으로 이동",
            style: .default,
            handler: { _ in
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        )
        
        authAlertController.addAction(getAuthAction)
        self.present(authAlertController, animated: true, completion: nil)
    }
}

extension LocationViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByGesture {
            let location = CLLocationCoordinate2D(
                latitude: mapView.cameraPosition.target.lat,
                longitude: mapView.cameraPosition.target.lng
            )
            self.changeMapLocation.accept(location)
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        if reason == NMFMapChangedByGesture {
            let location = CLLocationCoordinate2D(
                latitude: mapView.cameraPosition.target.lat,
                longitude: mapView.cameraPosition.target.lng
            )
            self.changeMapLocation.accept(location)
        }
    }
}
