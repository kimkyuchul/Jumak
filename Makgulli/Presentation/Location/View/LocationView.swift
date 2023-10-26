//
//  LocationView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import UIKit

import RxSwift
import RxCocoa
import NMapsMap

final class LocationView: BaseView {
    
    lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        mapView.zoomLevel = 13
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    let questionButton = DefaultCircleButton(image: ImageLiteral.mapQuestionIcon, tintColor: .brown, backgroundColor: .white)
    let userAddressButton = UserAddressButton()
    lazy var categoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCategoryLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        return collectionView
    }()
    let researchButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        let attributedTitle = NSAttributedString(string: StringLiteral.reSearchButton,
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._16),
                                                    .foregroundColor: UIColor.white
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.reSearchArrowIcon
        configuration.baseForegroundColor = .white
        configuration.imagePadding = 5
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        configuration.imagePlacement = .leading
        let button = UIButton()
        button.configuration = configuration
        button.backgroundColor = .brown
        button.alpha = 0.0
        return button
    }()
    let userLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        button.setImage(ImageLiteral.userLocationIcon, for: .normal)
        button.tintColor = .white
        return button
    }()
    lazy var storeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createStoreLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = false
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: "StoreCollectionViewCell")
        return collectionView
    }()
    fileprivate let storeEmptyView = StoreEmptyView()
    fileprivate let networkErrorView = NetworkErrorView()
    lazy var indicatorView  = IndicatorView(frame: .zero)
    
    var locationOverlay: NMFLocationOverlay?
    var visibleItemsRelay = PublishRelay<Int?>()
    
    fileprivate func moveCamera(latitude: Double, longitude: Double) {
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: latitude,lng: longitude),
            zoom: self.mapView.zoomLevel
        )
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        
        cameraUpdate.animation = .easeIn
        self.mapView.moveCamera(cameraUpdate)
    }
    
    fileprivate func handleResearchButtonVisibility(isHidden: Bool) {
        UIView.transition(
            with: self.researchButton,
            duration: 0.8,
            options: .curveEaseOut) { [weak self] in
                self?.researchButton.alpha = isHidden ? 0.0 : 1.0
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        researchButton.layer.cornerRadius = 20
        researchButton.dropShadow()
        userLocationButton.layer.cornerRadius = userLocationButton.frame.height / 2
        userLocationButton.dropShadow()
        storeEmptyView.layer.cornerRadius = 23
        storeEmptyView.dropShadow()
    }
    
    override func setHierarchy() {
        [mapView, questionButton, userAddressButton, categoryCollectionView, researchButton, userLocationButton, storeCollectionView, networkErrorView, storeEmptyView, indicatorView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        questionButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(9)
            make.size.equalTo(46)
        }
        
        userAddressButton.snp.makeConstraints { make in
            make.leading.equalTo(questionButton.snp.trailing).offset(11)
            make.centerY.equalTo(questionButton.snp.centerY)
            make.trailing.equalToSuperview().inset(24)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(userAddressButton.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        
        researchButton.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(9)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        userLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(42)
            make.bottom.equalTo(storeCollectionView.snp.top).offset(-24)
        }
        
        storeCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.height.equalTo(135)
        }
        
        networkErrorView.snp.makeConstraints { make in
            make.top.equalTo(storeCollectionView.snp.top)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(storeCollectionView.snp.bottom)
        }
        
        storeEmptyView.snp.makeConstraints { make in
            make.top.equalTo(storeCollectionView.snp.top)
            make.leading.trailing.equalToSuperview().inset(48)
            make.bottom.equalTo(storeCollectionView.snp.bottom)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setLayout() {
        self.backgroundColor = .lightGray
    }
}

extension Reactive where Base: LocationView {
    var cameraPosition: Binder<(Double, Double)> {
        return Binder(self.base) { view, cameraPosition in
            let (latitude, longitude) = cameraPosition
            view.moveCamera(latitude: latitude, longitude: longitude)
        }
    }
    
    var handleResearchButtonVisibility: Binder<Bool> {
        return Binder(self.base) { view, isHidden in
            view.handleResearchButtonVisibility(isHidden: isHidden)
        }
    }
    
    var handleStoreEmptyViewVisibility: Binder<Bool> {
        return Binder(self.base) { view, isHidden in
            view.storeEmptyView.isHidden = isHidden
        }
    }
    
    var handleNetworkErrorViewVisibility: Binder<Bool> {
        return Binder(self.base) { view, isHidden in
            view.networkErrorView.isHidden = isHidden
        }
    }
}

private extension LocationView {
    func createCategoryLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(46))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.interGroupSpacing = 11
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = configuration
        
        return layout
    }
    
    func createStoreLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(135))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
            visibleItems.forEach { item in
                let intersectedRect = item.frame.intersection(CGRect(x: offset.x, y: offset.y, width: env.container.contentSize.width, height: item.frame.height))
                let percentVisible = intersectedRect.width / item.frame.width
                
                if percentVisible >= 1.0 {
                    if let currentIndex = visibleItems.last?.indexPath.row {
                        self?.visibleItemsRelay.accept(currentIndex)
                    }
                }
                
                let scale = 0.5 + (0.5 * percentVisible)
                item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
            }
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
