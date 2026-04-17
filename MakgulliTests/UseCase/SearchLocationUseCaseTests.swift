import XCTest
import RxSwift
import RxBlocking
@testable import Makgulli

final class SearchLocationUseCaseTests: XCTestCase {

    private var sut: DefaultSearchLocationUseCase!
    private var mockRepository: MockSearchLocationRepository!
    private var mockLocalRepository: MockSearchLocationLocalRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockSearchLocationRepository()
        mockLocalRepository = MockSearchLocationLocalRepository()
        sut = DefaultSearchLocationUseCase(
            searchLocationRepository: mockRepository,
            searchLocationLocalRepository: mockLocalRepository
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockLocalRepository = nil
        super.tearDown()
    }

    // MARK: - fetchLocation

    func test_givenValidQuery_whenFetchLocation_thenReturnsSearchResult() throws {
        // Given
        let expectedStores = [StoreVOFactory.make(id: "1"), StoreVOFactory.make(id: "2")]
        let expectedResult = SearchLocationVO(meta: MetaVO(is_end: false), stores: expectedStores)
        mockRepository.fetchLocationResult = .just(expectedResult)

        // When
        let result = try sut.fetchLocation(query: "막걸리", x: "126.97", y: "37.57", page: 1, display: 15)
            .toBlocking(timeout: 1.0)
            .first()

        // Then
        XCTAssertEqual(result?.stores.count, 2)
        XCTAssertEqual(result?.meta.is_end, false)
    }

    // MARK: - updateWillDisplayStoreCell

    func test_givenStoreList_whenUpdateWillDisplayStoreCell_thenReturnsUpdatedStore() throws {
        // Given
        let store = StoreVOFactory.make(id: "store-001", rate: 3)
        mockLocalRepository.updateWillDisplayResult = .just(store)

        // When
        let result = try sut.updateWillDisplayStoreCell(index: 0, storeList: [store])
            .toBlocking(timeout: 1.0)
            .first()

        // Then
        XCTAssertEqual(result?.id, "store-001")
        XCTAssertEqual(result?.rate, 3)
    }

    // MARK: - updateStoreCell

    func test_givenStore_whenUpdateStoreCell_thenReturnsOptionalStore() {
        // Given
        let store = StoreVOFactory.make(id: "store-001")
        mockLocalRepository.updateStoreCellResult = store

        // When
        let result = sut.updateStoreCell(store)

        // Then
        XCTAssertEqual(result?.id, "store-001")
    }
}
