import XCTest
import RxSwift
import RxBlocking
@testable import Makgulli

final class LocationDetailUseCaseTests: XCTestCase {

    private var sut: DefaultLocationDetailUseCase!
    private var mockRepository: MockLocationDetailRepository!
    private var mockLocalRepository: MockLocationDetailLocalRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockLocationDetailRepository()
        mockLocalRepository = MockLocationDetailLocalRepository()
        sut = DefaultLocationDetailUseCase(
            locationDetailRepository: mockRepository,
            locationDetailLocalRepository: mockLocalRepository
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockLocalRepository = nil
        super.tearDown()
    }

    // MARK: - syncStore

    func test_givenNotExistsAndNoData_whenSyncStore_thenCompletesWithoutAnyCalls() {
        // Given
        mockLocalRepository.checkContainsStoreResult = false
        let store = StoreVOFactory.make(rate: 0, bookmark: false, episode: [])

        // When
        let result = sut.syncStore(store).toBlocking(timeout: 1.0).materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.createStoreCallCount, 0)
            XCTAssertEqual(mockLocalRepository.updateStoreCallCount, 0)
            XCTAssertEqual(mockLocalRepository.deleteStoreCallCount, 0)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }

    func test_givenNotExistsAndHasRate_whenSyncStore_thenCreatesStore() {
        // Given
        mockLocalRepository.checkContainsStoreResult = false
        let store = StoreVOFactory.make(rate: 3)

        // When
        let result = sut.syncStore(store).toBlocking(timeout: 1.0).materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.createStoreCallCount, 1)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }

    func test_givenExistsAndNoData_whenSyncStore_thenDeletesStore() {
        // Given
        mockLocalRepository.checkContainsStoreResult = true
        let store = StoreVOFactory.make(rate: 0, bookmark: false, episode: [])

        // When
        let result = sut.syncStore(store).toBlocking(timeout: 1.0).materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.deleteStoreCallCount, 1)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }

    func test_givenExistsAndHasDataAndShouldUpdate_whenSyncStore_thenUpdatesStore() {
        // Given
        mockLocalRepository.checkContainsStoreResult = true
        mockLocalRepository.shouldUpdateStoreResult = true
        let store = StoreVOFactory.make(bookmark: true)

        // When
        let result = sut.syncStore(store).toBlocking(timeout: 1.0).materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.updateStoreCallCount, 1)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }

    func test_givenExistsAndHasDataButNoUpdate_whenSyncStore_thenCompletesWithoutUpdate() {
        // Given
        mockLocalRepository.checkContainsStoreResult = true
        mockLocalRepository.shouldUpdateStoreResult = false
        let store = StoreVOFactory.make(rate: 5)

        // When
        let result = sut.syncStore(store).toBlocking(timeout: 1.0).materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.updateStoreCallCount, 0)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }
}
