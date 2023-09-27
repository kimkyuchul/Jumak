//
//  Task.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import Alamofire


enum Task {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}
