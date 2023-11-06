//
//  LocationDetailLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RxSwift

protocol LocationDetailLocalRepository: AnyObject {
    func createStore(_ store: StoreVO) -> Completable
    func updateStore(_ store: StoreVO) -> Completable
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO?
    func deleteStore(_ store: StoreVO) -> Completable
    func checkContainsStore(_ id: String) -> Bool
    func shouldUpdateStore(_ store: StoreVO) -> Bool
}
