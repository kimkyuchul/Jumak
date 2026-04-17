import Foundation
import RxSwift
@testable import Makgulli

final class MockFavoriteRepository: FavoriteRepository {
    var fetchBookmarkStoreResult: Single<[StoreVO]> = .just([])
    var fetchBookmarkStoreSortedByRatingResult: Single<[StoreVO]> = .just([])
    var fetchStoreSortedByRatingResult: Single<[StoreVO]> = .just([])
    var fetchStoreSortedByEpisodeCountResult: Single<[StoreVO]> = .just([])
    var fetchBookmarkStoreSortedByEpisodeCountResult: Single<[StoreVO]> = .just([])
    var fetchStoreSortedByNameResult: Single<[StoreVO]> = .just([])

    var lastCalledMethod: String?
    var lastSortAscending: Bool?

    func fetchBookmarkStore(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        lastCalledMethod = "fetchBookmarkStore"
        lastSortAscending = sortAscending
        return fetchBookmarkStoreResult
    }

    func fetchBookmarkStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        lastCalledMethod = "fetchBookmarkStoreSortedByRating"
        lastSortAscending = sortAscending
        return fetchBookmarkStoreSortedByRatingResult
    }

    func fetchStoreSortedByRating(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        lastCalledMethod = "fetchStoreSortedByRating"
        lastSortAscending = sortAscending
        return fetchStoreSortedByRatingResult
    }

    func fetchStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        lastCalledMethod = "fetchStoreSortedByEpisodeCount"
        lastSortAscending = sortAscending
        return fetchStoreSortedByEpisodeCountResult
    }

    func fetchBookmarkStoreSortedByEpisodeCount(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        lastCalledMethod = "fetchBookmarkStoreSortedByEpisodeCount"
        lastSortAscending = sortAscending
        return fetchBookmarkStoreSortedByEpisodeCountResult
    }

    func fetchStoreSortedByName(sortAscending: Bool, categoryFilter: CategoryFilterType) -> Single<[StoreVO]> {
        lastCalledMethod = "fetchStoreSortedByName"
        lastSortAscending = sortAscending
        return fetchStoreSortedByNameResult
    }
}
