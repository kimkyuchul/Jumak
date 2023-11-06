//
//  LocationStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/04.
//

import Foundation

import RealmSwift
import RxSwift

protocol LocationStorage: AnyObject {
    func updateStoreCellObservable(index: Int, storeList: [StoreVO]) -> Single<StoreVO>
    func updateStoreCell(store: StoreVO) -> StoreVO?
}

final class DefaultLocationStorage: BaseRealmStorage, LocationStorage {
    
    // willDisplayCell에서 그려질 셀에 대해 필터링을 진행하는 메서드 ex) 다른뷰 이동 후 다시 재진입 시
    func updateStoreCellObservable(index: Int, storeList: [StoreVO]) -> Single<StoreVO> {
        return Single.create { single in
            var store = storeList[index]
            
            do {
                try self.realm.write {
                    let storeTable = self.realm.objects(StoreTable.self).where {
                        $0.id == store.id
                    }.first
                    
                    if let storeTable {
                        store.bookmark = storeTable.bookmark
                        store.rate = storeTable.rate
                    } else {
                        store.bookmark = false
                        store.rate = 0
                    }
                }
                
                single(.success(store))
            } catch let error {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    // rx.modelSelected, rx.items에서 현재 그려진 셀에 대해 필터링을 진행하는 메서드
    func updateStoreCell(store: StoreVO) -> StoreVO? {
        do {
            var updatedStore = store
            
            try realm.write {
                if let storeTable = realm.objects(StoreTable.self).filter("id == %@", updatedStore.id).first {
                    updatedStore.bookmark = storeTable.bookmark
                    updatedStore.bookmarkDate = storeTable.bookmarkDate
                    updatedStore.rate = storeTable.rate
                }
            }
            
            return updatedStore
        } catch {
            print("Error updating store item: \(error)")
            return nil
        }
    }
}
