//
//  SearchLocationVO.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

struct SearchLocationVO {
    let meta: MetaVO
    let stores: [StoreVO]
}

struct MetaVO {
    let is_end: Bool
}
