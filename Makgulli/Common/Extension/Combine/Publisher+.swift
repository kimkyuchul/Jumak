//
//  Publisher+.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import UIKit
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

extension Publisher {
    func asyncMap<T>(_ transform: @escaping (Output) async -> T) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                _Concurrency.Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}
