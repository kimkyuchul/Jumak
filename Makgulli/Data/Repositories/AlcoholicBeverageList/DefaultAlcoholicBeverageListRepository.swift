//
//  DefaultAlcoholicBeverageListRepository.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation
import Combine

final class DefaultAlcoholicBeverageListRepository: AlcoholicBeverageListRepository {
    private let networkManager: any NetworkSessionable
    
    init(networkManager: any NetworkSessionable) {
        self.networkManager = networkManager
    }
    
    func fetchAlcoholicBeverageList(page: Int) -> AnyPublisher<AlcoholicBeverage, Error> {
        return networkManager.request(AlcoholicBeverageAPI.fetchTraditionalAlcoholicBeverage(page: page, perPage: 20), type: AlcoholicBeverageDTO.self)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}