//
//  SearchAlcoholUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import RxSwift

protocol SearchAlcoholUseCase: AnyObject {
    func searchByFirstLetter(_ letter: String) -> Single<[AlcoholVO]>
}

final class DefaultSearchAlcoholUseCase: SearchAlcoholUseCase {
    private let searchAlcoholRepository: SearchAlcoholRepository

    init(searchAlcoholRepository: SearchAlcoholRepository) {
        self.searchAlcoholRepository = searchAlcoholRepository
    }

    func searchByFirstLetter(_ letter: String) -> Single<[AlcoholVO]> {
        searchAlcoholRepository.searchByFirstLetter(letter)
    }
}
