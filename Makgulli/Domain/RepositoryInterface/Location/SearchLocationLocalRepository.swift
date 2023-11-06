//
//  SearchLocationLocalRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/05.
//

import Foundation

import RxSwift

protocol SearchLocationLocalRepository: AnyObject {
    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO]) -> Single<StoreVO>
    func updateStoreCell(store: StoreVO) -> StoreVO?
}
