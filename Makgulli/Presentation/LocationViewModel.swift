//
//  LocationViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

import RxSwift
import RxRelay

class LocationViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    private let searchLocationUseCase: SearchLocationUseCase
    
    init(searchLocationUseCase: SearchLocationUseCase) {
        self.searchLocationUseCase = searchLocationUseCase
    }
    
    deinit {
        print("Deinit LocationViewModel")
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let locationVO = PublishRelay<SearchLocationVO>()
    }
    
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.searchLocationUseCase.fetchLocation(query: "막걸리", x: "127.06283102249932", y: "37.514322572335935", page: 1, display: 30)
            })
            .disposed(by: disposeBag)
        
        
        let locationVO = searchLocationUseCase.locationVO
        
        locationVO
            .subscribe(onNext: { locationVO in
                output.locationVO.accept(locationVO)
            }) { error in
                print(error)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
