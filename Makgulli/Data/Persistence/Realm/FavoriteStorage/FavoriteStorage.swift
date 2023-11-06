//
//  FavoriteStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/04.
//

import Foundation

import RealmSwift

protocol FavoriteStorage {
    func fetchBookmarkStore(sortAscending: Bool) -> Results<StoreTable>
    func fetchStoreSortedByRating(sortAscending: Bool) -> Results<StoreTable>
    func fetchBookmarkStoreSortedByRating(sortAscending: Bool) -> Results<StoreTable>
    func fetchStoreSortedByEpisodeCount(sortAscending: Bool) -> Results<StoreTable>
    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool) -> Results<StoreTable>
    func fetchStoreSortedByName(sortAscending: Bool) -> Results<StoreTable>
}

final class DefaultFavoriteStorage: BaseRealmStorage {
    
    func fetchBookmarkStore(sortAscending: Bool) -> Results<StoreTable> {
        let storeValue = self.realm.objects(StoreTable.self)
            .sorted(byKeyPath: "bookmarkDate", ascending: sortAscending)
            .filter("bookmark == %@", true)
        return storeValue
    }
    
    func fetchStoreSortedByRating(sortAscending: Bool) -> Results<StoreTable> {
        let sortProperties = [SortDescriptor(keyPath: "rate", ascending: sortAscending),
                              SortDescriptor(keyPath: "date", ascending: false)]
        
        let storeValue = self.realm.objects(StoreTable.self)
            .sorted(by: sortProperties)
            .filter("rate != %@", 0)
        
        return storeValue
    }
    
    func fetchBookmarkStoreSortedByRating(sortAscending: Bool) -> Results<StoreTable> {
        let sortProperties = [SortDescriptor(keyPath: "rate", ascending: sortAscending),
                              SortDescriptor(keyPath: "date", ascending: false)]
        
        let storeValue = self.realm.objects(StoreTable.self)
            .sorted(by: sortProperties)
            .filter("rate != %@", 0)
            .filter("bookmark == %@", true)
        
        return storeValue
    }
    
    func fetchStoreSortedByEpisodeCount(sortAscending: Bool) -> Results<StoreTable> {
        let storeValue = self.realm.objects(StoreTable.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        return storeValue
    }
    
    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool) -> Results<StoreTable> {
        let storeValue = self.realm.objects(StoreTable.self)
            .sorted(byKeyPath: "date", ascending: false)
            .filter("bookmark == %@", true)
        
        return storeValue
    }
    
    func fetchStoreSortedByName(sortAscending: Bool) -> Results<StoreTable> {
        let storeValue = self.realm.objects(StoreTable.self)
            .sorted(byKeyPath: "placeName", ascending: sortAscending)
        
        return storeValue
    }
}

