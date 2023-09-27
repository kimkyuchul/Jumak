//
//  SearchLocationUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

import RxSwift
import RxRelay

protocol SearchLocationUseCase {
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int)
    var locationVO: PublishSubject<SearchLocationVO> { get }
}

final class DefaultSearchLocationUseCase: SearchLocationUseCase {
    
    private let searchLocationRepository: SearchLocationRepository
    private let disposebag = DisposeBag()
    
    var locationVO = PublishSubject<SearchLocationVO>()
    
    init(searchLocationRepository: SearchLocationRepository) {
        self.searchLocationRepository = searchLocationRepository
    }
    
    
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) {
        searchLocationRepository.fetchLocation(query: query, x: x, y: y, page: page, display: display)
            .subscribe(with: self, onSuccess: { owner, response  in
                owner.locationVO.onNext(response)
            }, onFailure: { owner, error in
                owner.locationVO.onError(error)
            })
            .disposed(by: disposebag)
    }
    
}