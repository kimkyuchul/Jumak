//
//  SearchLocationUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

import RxSwift

protocol SearchLocationUseCase: AnyObject {
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) -> Single<SearchLocationVO>
    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO]) -> Single<StoreVO>
    func updateStoreCell(_ store: StoreVO) -> StoreVO?
}

final class DefaultSearchLocationUseCase: SearchLocationUseCase {
    private let searchLocationRepository: SearchLocationRepository
    private let searchLocationLocalRepository: SearchLocationLocalRepository

    init(
        searchLocationRepository: SearchLocationRepository,
        searchLocationLocalRepository: SearchLocationLocalRepository
    ) {
        self.searchLocationRepository = searchLocationRepository
        self.searchLocationLocalRepository = searchLocationLocalRepository
    }

    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) -> Single<SearchLocationVO> {
        searchLocationRepository.fetchLocation(query: query, x: x, y: y, page: page, display: display)
    }

    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO]) -> Single<StoreVO> {
        searchLocationLocalRepository.updateWillDisplayStoreCell(index: index, storeList: storeList)
    }

    func updateStoreCell(_ store: StoreVO) -> StoreVO? {
        searchLocationLocalRepository.updateStoreCell(store: store)
    }
}
