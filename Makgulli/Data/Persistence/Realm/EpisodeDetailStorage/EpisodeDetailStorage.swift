//
//  EpisodeDetailStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/06.
//

import Foundation

import RealmSwift
import RxSwift

protocol EpisodeDetailStorage: AnyObject {
    func deleteEpisode(id: String, episodeId: String) -> Completable
}

final class DefaultEpisodeDetailStorage: BaseRealmStorage, EpisodeDetailStorage {
    
    func deleteEpisode(id: String, episodeId: String) -> Completable {
        guard let storeObject = realm.object(
            ofType: StoreTable.self,
            forPrimaryKey: id
        ) else { return .empty() }
        
        return Completable.create { completable in
            do {
                try self.realm.write {
                    if let objectId = try? ObjectId(string: episodeId), let episodeTable = self.realm.objects(EpisodeTable.self).filter("_id == %@", objectId).first {
                        if let index = storeObject.episode.firstIndex(of: episodeTable) {
                            storeObject.episode.remove(at: index)
                            self.realm.add(storeObject, update: .modified)
                        }
                    }
                }
                completable(.completed)
            } catch let error {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
}

