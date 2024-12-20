//
//  LocationDetailView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/03.
//

import UIKit

import NMapsMap
import RxSwift
import RxCocoa

final class LocationDetailView: BaseView {
    
    fileprivate let navigationBar: JumakNavigationBar = {
        let navigationBar = JumakNavigationBar()
        navigationBar.setTitle("상세 정보")
        return navigationBar
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topCornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners(cornerRadius: 23, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        return view
    }()
    private lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        mapView.zoomLevel = 13
        return mapView
    }()
    let storeLocationButton = LocationButton()
    let titleView = DetailTitleView()
    let rateView = DetailRateView()
    let infoView = DetailInfoView()
    let episodeView = DetailEpisodeView()
    let bottomView = DetailBottomView()
    
    private var storemarker = NMFMarker()
    
    func applyCollectionViewDataSource(
        by viewModels: [Episode]
    ) {
        var snapshot = DetailEpisodeView.Snapshot()
        
        snapshot.appendSections([.episode])
        snapshot.appendItems(viewModels, toSection: .episode)
        
        episodeView.dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
            let lastItemIndex = viewModels.count - 1
            let indexPath = IndexPath(item: lastItemIndex, section: 0)
            self?.episodeView.episodeCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func itemIdentifier(for indexPath: IndexPath) -> Episode? {
        return episodeView.dataSource?.itemIdentifier(for: indexPath)
    }
    
    fileprivate func moveCamera(latitude: Double, longitude: Double) {
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: latitude,lng: longitude),
            zoom: self.mapView.zoomLevel
        )
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        
        cameraUpdate.animation = .easeIn
        self.mapView.moveCamera(cameraUpdate)
    }
    
    fileprivate func setUpMarker(latitude: Double, longitude: Double) {
        self.storemarker.mapView = nil
        
        let position = NMGLatLng(lat: latitude, lng: longitude)
        let markerIcon = NMFOverlayImage(image: ImageLiteral.touchMarker)
        
        self.storemarker = NMFMarker(position: position, iconImage: markerIcon)
        self.storemarker.width = DesignLiteral.touchMarkerWidth
        self.storemarker.height = DesignLiteral.touchMarkerheight
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        cameraUpdate.animation = .easeIn
        
        self.mapView.moveCamera(cameraUpdate)
        self.storemarker.mapView = self.mapView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topCornerView.dropShadow(color: .black, offset: CGSize(width: 0, height: 18), opacity: 0.2, radius: 10)
    }
    
    override func setHierarchy() {
        self.addSubview(navigationBar)
        self.addSubview(scrollView)
        self.addSubview(bottomView)
        scrollView.addSubview(contentView)
        
        [topCornerView,
         mapView,
         storeLocationButton,
         titleView,
         rateView,
         infoView,
         episodeView
        ].forEach {
            contentView.addSubview($0)
        }
        
        contentView.bringSubviewToFront(topCornerView)
    }
    
    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalTo(navigationBar.snp.horizontalEdges)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        topCornerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.03)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(topCornerView.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
        }
        
        storeLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(titleView.snp.top).offset(-24)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).inset(42)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.2)
        }
        
        rateView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(30).priority(.high)
            make.leading.equalTo(titleView.snp.leading)
            make.trailing.equalTo(titleView.snp.trailing)
            make.height.equalTo(self.snp.height).multipliedBy(0.15)
            make.centerX.equalTo(titleView.snp.centerX)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(rateView.snp.bottom).offset(18).priority(.high)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(self.snp.height).multipliedBy(0.26)
        }
        
        episodeView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(18).priority(.high)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
            make.bottom.equalToSuperview().inset(15)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func setLayout() {
        scrollView.bounces = false
        scrollView.backgroundColor = .lightGray
        contentView.backgroundColor = .lightGray
    }
}

extension Reactive where Base: LocationDetailView {
    var backButtonTap: Observable<Void> {
        return self.base.navigationBar.backButtonAction()
    }
    
    var selectedItem: ControlEvent<IndexPath> {
        return self.base.episodeView.episodeCollectionView.rx.itemSelected
    }
    
    var storeCameraPosition: Binder<(Double, Double)> {
        return Binder(self.base) { view, cameraPosition in
            let (latitude, longitude) = cameraPosition
            view.moveCamera(latitude: latitude, longitude: longitude)
        }
    }
    
    var setUpMarker: Binder<(Double, Double)> {
        return Binder(self.base) { view, position in
            let (latitude, longitude) = position
            view.setUpMarker(latitude: latitude, longitude: longitude)
        }
    }
}
