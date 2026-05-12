//
//  SearchAlcoholUseCaseTests.swift
//  MakgulliTests
//
//  Created by 김규철 on 2026/05/11.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Makgulli

final class SearchAlcoholUseCaseTests: XCTestCase {

    private var sut: DefaultSearchAlcoholUseCase!
    private var mockRepository: MockSearchAlcoholRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchAlcoholRepository()
        sut = DefaultSearchAlcoholUseCase(searchAlcoholRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - searchByFirstLetter

    func test_givenLetterReturnsAlcohols_whenSearch_thenForwardsList() throws {
        // Given
        let expected = [
            AlcoholVOFactory.make(id: "1", name: "A1"),
            AlcoholVOFactory.make(id: "2", name: "Apple Martini")
        ]
        mockRepository.searchByFirstLetterResult = .just(expected)

        // When
        let result = try sut.searchByFirstLetter("a")
            .toBlocking(timeout: 1.0)
            .first()

        // Then
        XCTAssertEqual(mockRepository.lastCalledLetter, "a")
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?[0].id, "1")
        XCTAssertEqual(result?[1].name, "Apple Martini")
    }

    func test_givenLetterReturnsEmpty_whenSearch_thenReturnsEmpty() throws {
        // Given
        mockRepository.searchByFirstLetterResult = .just([])

        // When
        let result = try sut.searchByFirstLetter("z")
            .toBlocking(timeout: 1.0)
            .first()

        // Then
        XCTAssertEqual(mockRepository.lastCalledLetter, "z")
        XCTAssertEqual(result?.count, 0)
    }

    func test_givenRepositoryError_whenSearch_thenPropagatesError() {
        // Given
        let expectedError = NetworkError.decodingError
        mockRepository.searchByFirstLetterResult = .error(expectedError)

        // When
        let materialized = sut.searchByFirstLetter("a")
            .toBlocking(timeout: 1.0)
            .materialize()

        // Then
        switch materialized {
        case .completed:
            XCTFail("expected error, got completion")
        case .failed(_, let error):
            XCTAssertEqual(error as? NetworkError, expectedError)
        }
    }
}
