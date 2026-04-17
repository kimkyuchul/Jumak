import XCTest
import RxSwift
import RxBlocking
@testable import Makgulli

final class FavoriteUseCaseTests: XCTestCase {

    private var sut: DefaultFavoriteUseCase!
    private var mockRepository: MockFavoriteRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoriteRepository()
        sut = DefaultFavoriteUseCase(favoriteRepository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - fetchFilterStore

    func test_givenRecentlyAddedBookmark_whenFetchFilterStore_thenCallsFetchBookmarkStore() throws {
        // Given
        let stores = [StoreVOFactory.make(id: "1", bookmark: true)]
        mockRepository.fetchBookmarkStoreResult = .just(stores)

        // When
        let result = try sut.fetchFilterStore(
            filterType: .recentlyAddedBookmark,
            reverseFilter: false,
            categoryFilter: .all
        )
        .toBlocking(timeout: 1.0)
        .first()

        // Then
        XCTAssertEqual(mockRepository.lastCalledMethod, "fetchBookmarkStore")
        XCTAssertEqual(result?.count, 1)
    }

    func test_givenSortByName_whenFetchFilterStore_thenReversesReverseFilter() throws {
        // Given
        mockRepository.fetchStoreSortedByNameResult = .just([])

        // When
        _ = try sut.fetchFilterStore(
            filterType: .sortByName,
            reverseFilter: false,
            categoryFilter: .all
        )
        .toBlocking(timeout: 1.0)
        .first()

        // Then
        XCTAssertEqual(mockRepository.lastCalledMethod, "fetchStoreSortedByName")
        XCTAssertEqual(mockRepository.lastSortAscending, true)
    }
}
