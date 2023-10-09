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
    func updateStoreCellObservable(index: Int, storeList: [StoreVO])
    func updateStoreCell(_ store: StoreVO) -> StoreVO?
    
    var storeVO: PublishSubject<SearchLocationVO> { get }
    var updateStoreVO: PublishSubject<StoreVO> { get }
}

final class DefaultSearchLocationUseCase: SearchLocationUseCase {
    
    enum SearchLocationError: Error {
        case updateStoreCell
    }
    
    private let searchLocationRepository: SearchLocationRepository
    private let realmRepository: RealmRepository
    private let disposebag = DisposeBag()
    
    var storeVO = PublishSubject<SearchLocationVO>()
    var updateStoreVO = PublishSubject<StoreVO>()
    var errorSubject = PublishSubject<Error>()
    
    init(
        searchLocationRepository: SearchLocationRepository,
         realmRepository: RealmRepository
    ) {
        self.searchLocationRepository = searchLocationRepository
        self.realmRepository = realmRepository
    }
    
    
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) {
        searchLocationRepository.fetchLocation(query: query, x: x, y: y, page: page, display: display)
            .subscribe(with: self, onSuccess: { owner, response  in
                owner.storeVO.onNext(response)
            }, onFailure: { owner, error in
                owner.storeVO.onError(error)
            })
            .disposed(by: disposebag)
    }
    
    func updateStoreCellObservable(index: Int, storeList: [StoreVO]) {
        realmRepository.updateStoreCellObservable(index: index, storeList: storeList)
            .subscribe(with: self, onSuccess: { owner, storeVO  in
                owner.updateStoreVO.onNext(storeVO)        
            }, onFailure: { owner, error in
                owner.errorSubject.onNext(error)
            })
            .disposed(by: disposebag)
    }
    
    func updateStoreCell(_ store: StoreVO) -> StoreVO? {
        return realmRepository.updateStoreCell(store: store)
    }
}

