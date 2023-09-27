//
//  SearchLocationRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

import RxSwift

protocol SearchLocationRepository {
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) -> Single<SearchLocationVO>
}
