//
//  DefaultSearchAlcoholRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import Foundation

import RxSwift

final class DefaultSearchAlcoholRepository: SearchAlcoholRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func searchByFirstLetter(_ letter: String) -> Single<[AlcoholVO]> {
        let api = CocktailAPI.searchByFirstLetter(letter)
        return networkService.request(api, type: CocktailSearchResponseDTO.self)
            .map { $0.drinks.map { $0.toDomain() } }
    }
}
