//
//  NetworkError.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/26.
//

import Foundation

enum NetworkError: Error, CustomDebugStringConvertible {
    /// not contains 200~299.
    case isNotSuccessful(statusCode: Int)
    /// decoding error.
    case decodingError
    /// server error.
    case underlyingError(message: String)
}

extension NetworkError {
    public var debugDescription: String {
        switch self {
        case .isNotSuccessful(let statusCode):
            return "not contains 200~299 : `\(statusCode)`"
        case .decodingError:
            return "decoding error."
        case .underlyingError(let message):
            return "server error \(message)"
        }
    }
}
