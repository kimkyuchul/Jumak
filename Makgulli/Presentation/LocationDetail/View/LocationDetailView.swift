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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topCornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        view.roundCorners(cornerRadius: 23, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        return view
    }()
    lazy var mapView: NMFMapView = {
        let mapView = NMFMapView()
        mapView.allowsZooming = true
        mapView.logoInteractionEnabled = false
        mapView.positionMode = .direction
        mapView.zoomLevel = 15
        self.locationOverlay = mapView.locationOverlay
        return mapView
    }()
    let storeLocationButton = LocationButton()
    let titleView = DetailTitleView()
    let rateView = DetailRateView()
    let infoView = DetailInfoView()
    let episodeView = DetailEpisodeView()
    let bottomView = DetailBottomView()
    
    var locationOverlay: NMFLocationOverlay?
        
    func applyCollectionViewDataSource(
        by viewModels: [EpisodeVO]
    ) {
        var snapshot = DetailEpisodeView.Snapshot()
        
        snapshot.appendSections([.episode])
        snapshot.appendItems(viewModels, toSection: .episode)
        
        episodeView.dataSource?.apply(snapshot)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topCornerView.dropShadow(color: .black, offset: CGSize(width: 0, height: 18), opacity: 0.2, radius: 10)
    }
    
    override func setHierarchy() {
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
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
            make.height.equalTo(1000)
        }
        
        topCornerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.05)
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
            make.top.equalTo(titleView.snp.bottom).offset(30)
            make.leading.equalTo(titleView.snp.leading)
            make.trailing.equalTo(titleView.snp.trailing)
            make.centerX.equalTo(titleView.snp.centerX)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(rateView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        episodeView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(10).priority(.low)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func setLayout() {
        contentView.backgroundColor = .lightGray
    }
}