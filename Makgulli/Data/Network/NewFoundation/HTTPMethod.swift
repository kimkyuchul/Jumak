//
//  HTTPMethod.swift
//  Makgulli
//
//  Created by kyuchul on 11/29/24.
//

import Foundation

enum HTTPMethodType: String {
    /// `GET` HTTP Method.
    case get = "GET"
    /// `POST` HTTP Method.
    case post = "POST"
    /// `PATCH` HTTP Method.
    case patch = "PATCH"
    /// `PUT` HTTP Method.
    case put = "PUT"
    /// `Delete` HTTP Method.
    case delete = "DELETE"
}
