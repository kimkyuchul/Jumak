import Foundation
import RxSwift
@testable import Makgulli

final class MockWriteEpisodeLocalRepository: WriteEpisodeLocalRepository {
    var createStoreResult: Completable = .empty()
    var createStoreTableResult: Completable = .empty()
    var updateEpisodeResult: Completable = .empty()
    var checkContainsStoreResult: Bool = false

    var createStoreTableCallCount = 0
    var updateEpisodeCallCount = 0

    func createStore(_ store: StoreVO) -> Completable {
        createStoreResult
    }

    func createStoreTable(_ store: StoreTable) -> Completable {
        createStoreTableCallCount += 1
        return createStoreTableResult
    }

    func updateEpisode(id: String, episode: EpisodeTable) -> Completable {
        updateEpisodeCallCount += 1
        return updateEpisodeResult
    }

    func checkContainsStore(_ id: String) -> Bool {
        checkContainsStoreResult
    }
}
