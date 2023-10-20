//
//  UserDefaultHandler.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/19.
//

import Foundation

struct UserDefaultHandler {
    @UserDefault(key: "reverseFilter", defaultValue: false)
    static var reverseFilter: Bool
}
