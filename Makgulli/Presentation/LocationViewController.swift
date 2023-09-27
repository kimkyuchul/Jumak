//
//  LocationViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit
import NMapsMap

import RxSwift
import RxRelay
import RxCocoa

final class LocationViewController: UIViewController {
    private let viewModel = LocationViewModel(searchLocationUseCase: DefaultSearchLocationUseCase(searchLocationRepository: DefaultSearchLocationRepository(networkManager: NetworkManager())), locationUseCase: DefaultLocationUseCase(locationService: DefaultLocationManager()))
    
    var bag: DisposeBag = .init()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
        bind()
        
    }
    
    private func bind() {
        let input = LocationViewModel.Input(viewDidLoadEvent: Observable.just(()).asObservable())
        let output = viewModel.transform(input: input)
        
        output.locationVO
            .bind(onNext: { searchLocationVO in
                print(searchLocationVO)
            })
            .disposed(by: bag)
        
        output.currentUserLocation
            .bind(onNext: { location in
                print(location)
            })
            .disposed(by: bag)
        
        output.authorizationAlertShouldShow
            .bind(onNext: { authorization in
                print(authorization)
            })
            .disposed(by: bag)
    }
}
