//
//  DefaultSearchLocationRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/26.
//

import Foundation

import RxSwift

final class DefaultSearchLocationRepository: SearchLocationRepository {
    private let networkManager: any NetworkSessionable
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) -> Single<SearchLocationVO> {
        return networkManager.request(LocationAPI.fetchSearchLocations(query, x, y, page, display), type: SearchLocationDTO.self)
            .map { $0.toDomain() }
    }
}
