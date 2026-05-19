//
//  SearchAlcoholRepository.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import RxSwift

protocol SearchAlcoholRepository: AnyObject {
    func searchByFirstLetter(_ letter: String) -> Single<[AlcoholVO]>
}
