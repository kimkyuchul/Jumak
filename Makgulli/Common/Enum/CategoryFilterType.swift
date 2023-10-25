//
//  CategoryFilterType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import Foundation

enum CategoryFilterType: CaseIterable, ActionTitleable {
    case all
    case makgulli
    case pajeon
    case bossam
    
    var title: String {
        switch self {
        case .all:
            return "모두보기"
        case .makgulli:
            return "막걸리"
        case .pajeon:
            return "파전"
        case .bossam:
            return "보쌈"
        }
    }
}
