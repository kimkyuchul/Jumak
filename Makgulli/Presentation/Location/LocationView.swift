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

class LocationView: BaseView {
    
    lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    let questionButton = QuestionButton()
    let userAddressButton = UserAddressButton()
    lazy var categoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        return collectionView
    }()
    let researchButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .large
        let attributedTitle = NSAttributedString(string: "이 지역에서 다시 검색",
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
    
    
    var locationOverlay: NMFLocationOverlay?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        researchButton.layer.cornerRadius = 20
        researchButton.dropShadow()
    }
    
    override func setHierarchy() {
        [mapView, questionButton, userAddressButton, categoryCollectionView, researchButton].forEach {
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
    
    fileprivate func handleResearchButtonVisibility(isHidden: Bool) {
        UIView.transition(
            with: self.researchButton,
            duration: 0.8,
            options: .curveEaseOut) { [weak self] in
                self?.researchButton.alpha = isHidden ? 0.0 : 1.0
            }
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
}


private extension LocationView {
    func createLayout() -> UICollectionViewLayout {
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
}
