//
//  Publisher+.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Combine

extension Publisher {
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}
