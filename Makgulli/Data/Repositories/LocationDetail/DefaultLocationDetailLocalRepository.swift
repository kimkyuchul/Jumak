//
//  DefaultLocationDetailLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

final class DefaultLocationDetailLocalRepository: LocationDetailLocalRepository  {
    private let locationDetailStorage: LocationDetailStorage
    
    init(locationDetailStorage: LocationDetailStorage) {
        self.locationDetailStorage = locationDetailStorage
    }
    
    func createStore(_ store: StoreVO) -> Completable {
        locationDetailStorage.createStore(store)
    }
    
    func updateStore(_ store: StoreVO) -> Completable {
        locationDetailStorage.updateStore(store)
    }
    
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO? {
        locationDetailStorage.updateStoreEpisode(store)
    }
    
    func deleteStore(_ store: StoreVO) -> Completable {
        locationDetailStorage.deleteStore(store)
    }
    
    func checkContainsStore(_ id: String) -> Bool {
        locationDetailStorage.checkContainsStore(id)
    }
    
    func shouldUpdateStore(_ store: StoreVO) -> Bool {
        locationDetailStorage.shouldUpdateStore(store)
    }
}


