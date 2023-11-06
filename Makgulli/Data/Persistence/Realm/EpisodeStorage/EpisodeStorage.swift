//
//  EpisodeStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RealmSwift
import RxSwift

protocol EpisodeStorage: AnyObject {
    func createStoreTable(_ store: StoreTable) -> Completable
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable
}

final class DefaultEpisodeStorage: BaseRealmStorage, EpisodeStorage {
    
    func createStoreTable(_ store: StoreTable) -> Completable {
        return Completable.create { completable in
            do {
                try self.realm.write {
                    self.realm.add(store)
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    // 기존에 있던 store에 에피소드를 append
    func updateEpisode(id: String, episode: EpisodeTable) -> Completable {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: id
        ) else { return .empty() }
        
        return Completable.create { completable in
            do {
                try self.realm.write {
                    storeObject.episode.append(episode)
                    self.realm.add(storeObject, update: .modified)
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}

