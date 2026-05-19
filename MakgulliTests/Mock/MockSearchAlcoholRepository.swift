//
//  MockSearchAlcoholRepository.swift
//  MakgulliTests
//
//  Created by 김규철 on 2026/05/11.
//

import Foundation
import RxSwift
@testable import Makgulli

final class MockSearchAlcoholRepository: SearchAlcoholRepository {
    var searchByFirstLetterResult: Single<[AlcoholVO]> = .just([])
    var lastCalledLetter: String?

    func searchByFirstLetter(_ letter: String) -> Single<[AlcoholVO]> {
        lastCalledLetter = letter
        return searchByFirstLetterResult
    }
}
