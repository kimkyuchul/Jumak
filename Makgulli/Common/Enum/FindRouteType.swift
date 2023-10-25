//
//  FindRouteType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/21.
//

import Foundation

enum FindRouteType: CaseIterable {
    case naver
    case kakao
    case apple
    
    var title: String {
        switch self {
        case .naver:
            return "네이버맵으로 이동"
        case .kakao:
            return "카카오맵으로 이동"
        case .apple:
            return "애플맵으로 이동"
        }
    }
}
