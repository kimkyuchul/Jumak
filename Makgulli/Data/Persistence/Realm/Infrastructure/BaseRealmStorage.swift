//
//  BaseRealmStorage.swift
//  Makgulli
//
//  Created by 김규철 on 2023/11/05.
//

import Foundation

import RealmSwift

class BaseRealmStorage {
    let realm: Realm
    
    init?() {
        guard let realm = try? Realm() else { return nil }
        self.realm = realm
        
        if let fileURL = realm.configuration.fileURL {
            print("Realm fileURL \(String(describing: fileURL))")
        }
    }
}


