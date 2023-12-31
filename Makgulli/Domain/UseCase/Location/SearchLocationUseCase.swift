//
//  SearchLocationUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

import RxSwift
import RxRelay

protocol SearchLocationUseCase: AnyObject {
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int)
    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO])
    func updateStoreCell(_ store: StoreVO) -> StoreVO?
    
    var storeVO: PublishSubject<SearchLocationVO> { get }
    var updateStoreVO: PublishSubject<StoreVO> { get }
    var errorSubject: PublishSubject<Error> { get }
    var isLoding: PublishSubject<Bool> { get }
}

final class DefaultSearchLocationUseCase: SearchLocationUseCase {
    
    enum SearchLocationError: Error {
        case updateStoreCell
    }
    
    private let searchLocationRepository: SearchLocationRepository
    private let searchLocationLocalRepository: SearchLocationLocalRepository
    private let disposebag = DisposeBag()
    
    var storeVO = PublishSubject<SearchLocationVO>()
    var updateStoreVO = PublishSubject<StoreVO>()
    var errorSubject = PublishSubject<Error>()
    var isLoding = PublishSubject<Bool>()
    
    init(
        searchLocationRepository: SearchLocationRepository,
        searchLocationLocalRepository: SearchLocationLocalRepository
    ) {
        self.searchLocationRepository = searchLocationRepository
        self.searchLocationLocalRepository = searchLocationLocalRepository
    }
    
    
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) {
        searchLocationRepository.fetchLocation(query: query, x: x, y: y, page: page, display: display)
            .subscribe { [weak self] result in
                self?.isLoding.onNext(true)
                
                switch result {
                case .success(let storeList):
                    self?.storeVO.onNext(storeList)
                case .failure(let error):
                    self?.errorSubject.onNext(error)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.isLoding.onNext(false)
                }
            }
            .disposed(by: disposebag)
    }
    
    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO]) {
        searchLocationLocalRepository.updateWillDisplayStoreCell(index: index, storeList: storeList)
            .subscribe(with: self, onSuccess: { owner, storeVO  in
                owner.updateStoreVO.onNext(storeVO)
            }, onFailure: { owner, error in
                owner.errorSubject.onNext(error)
            })
            .disposed(by: disposebag)
    }
    
    func updateStoreCell(_ store: StoreVO) -> StoreVO? {
        return searchLocationLocalRepository.updateStoreCell(store: store)
    }
}

