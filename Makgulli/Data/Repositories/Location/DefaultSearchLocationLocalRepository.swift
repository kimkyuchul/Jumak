//
//  DefaultSearchLocationLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/05.
//

import Foundation

import RxSwift

final class DefaultSearchLocationLocalRepository: SearchLocationLocalRepository {
    private let locationStorage: LocationStorage
    
    init(locationStorage: LocationStorage) {
        self.locationStorage = locationStorage
    }
    
    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO]) -> Single<StoreVO> {
        locationStorage.updateStoreCellObservable(index: index, storeList: storeList)
    }
    
    func updateStoreCell(store: StoreVO) -> StoreVO? {
        locationStorage.updateStoreCell(store: store)
    }
}
