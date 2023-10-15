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
    
    private let viewModel = LocationViewModel(searchLocationUseCase: DefaultSearchLocationUseCase(searchLocationRepository: DefaultSearchLocationRepository(networkManager: NetworkManager()), realmRepository: DefaultRealmRepository()!), locationUseCase: DefaultLocationUseCase(locationService: DefaultLocationManager()))
    private var markers: [NMFMarker] = []
    private var selectCategoryType: CategoryType = .makgulli
    private var selectMarkerRelay = PublishRelay<Int?>()
    private var changeMapLocation = PublishRelay<CLLocationCoordinate2D>()
    
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
                   willDisplayCell: locationView.storeCollectionView.rx.willDisplayCell.map { $0.at },
                   didSelectMarker: selectMarkerRelay,
                   didSelectCategoryCell: locationView.categoryCollectionView.rx.itemSelected.asObservable().throttle(.seconds(2), scheduler: MainScheduler.asyncInstance),
                   changeMapLocation: changeMapLocation,
                   didSelectRefreshButton: locationView.researchButton.rx.tap.asObservable().throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
                   didSelectUserLocationButton: locationView.userLocationButton.rx.tap.asObservable().throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
                   didScrollStoreCollectionView: locationView.visibleItemsRelay.asObservable().debounce(.milliseconds(250), scheduler: MainScheduler.asyncInstance))
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
            .bind(onNext: { owner, data in
                let (selectedIndex, storeList) = data
                guard selectedIndex ?? 0 < storeList.count else { return }
                owner.setUpMarker(selectedIndex: selectedIndex, storeList: storeList)
                owner.locationView.storeCollectionView.selectItem(at: IndexPath(row: selectedIndex ?? 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
        
        output.setCameraPosition
            .asDriver(onErrorJustReturn: (LocationLiteral.longitude, LocationLiteral.latitude))
            .distinctUntilChanged { (prevPosition, newPosition) -> Bool in
                return prevPosition == newPosition
            }
            .drive(self.locationView.rx.cameraPosition)
            .disposed(by: disposeBag)
        
        output.currentUserLocation
            .withUnretained(self)
            .bind(onNext: { owner, location in
                owner.updateUserCurrentLocation(latitude: location.latitude, longitude: location.longitude)
            })
            .disposed(by: disposeBag)
        
        output.currentUserAddress
            .bind(to: locationView.userAddressButton.rx.addressTitle)
            .disposed(by: disposeBag)
        
        output.authorizationAlertShouldShow
            .bind(onNext: { authorization in
                print(authorization)
            })
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
            .withUnretained(self)
            .bind(onNext: { owner, type in
                owner.selectCategoryType = type
            })
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
    }
    
    override func bindAction() {
        locationView.questionButton.rx.tap
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self) { owner, _ in
                owner.present(QuestionViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(locationView.storeCollectionView.rx.modelSelected(StoreVO.self), locationView.storeCollectionView.rx.itemSelected)
            .withUnretained(self)
            .bind(onNext: { [weak self] data in
                guard let realmRepository = DefaultRealmRepository() else { return }
                
                if let updatedItem = self?.viewModel.updateStoreCell(data.1.0) {
                    let detailVC = LocationDetailViewController(viewModel: LocationDetailViewModel(storeVO: updatedItem, locationDetailUseCase: LocationDetailUseCase(realmRepository: realmRepository, locationDetailRepository: DefaultLocationDetailRepository(imageStorage: DefaultImageStorage(fileManager: FileManager())))))
                    detailVC.hidesBottomBarWhenPushed = true
                    data.0.navigationController?.pushViewController(detailVC, animated: true)
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
