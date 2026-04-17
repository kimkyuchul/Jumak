import Foundation
import RxSwift
@testable import Makgulli

final class MockLocationDetailLocalRepository: LocationDetailLocalRepository {
    var createStoreResult: Completable = .empty()
    var updateStoreResult: Completable = .empty()
    var deleteStoreResult: Completable = .empty()
    var checkContainsStoreResult: Bool = false
    var shouldUpdateStoreResult: Bool = false
    var updateStoreEpisodeResult: StoreVO?

    var createStoreCallCount = 0
    var updateStoreCallCount = 0
    var deleteStoreCallCount = 0

    func createStore(_ store: StoreVO) -> Completable {
        createStoreCallCount += 1
        return createStoreResult
    }

    func updateStore(_ store: StoreVO) -> Completable {
        updateStoreCallCount += 1
        return updateStoreResult
    }

    func updateStoreEpisode(_ store: StoreVO) -> StoreVO? {
        updateStoreEpisodeResult
    }

    func deleteStore(_ store: StoreVO) -> Completable {
        deleteStoreCallCount += 1
        return deleteStoreResult
    }

    func checkContainsStore(_ id: String) -> Bool {
        checkContainsStoreResult
    }

    func shouldUpdateStore(_ store: StoreVO) -> Bool {
        shouldUpdateStoreResult
    }
}
