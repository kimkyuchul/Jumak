//
//  DefaultSearchLocationRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import RxSwift

final class DefaultSearchLocationRepository: SearchLocationRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) -> Single<SearchLocationVO> {
        let api = LocationAPI.fetchSearchLocations(query, x, y, page, display)
        return networkService.request(api, type: SearchLocationDTO.self).map { $0.toDomain() }
    }
}
