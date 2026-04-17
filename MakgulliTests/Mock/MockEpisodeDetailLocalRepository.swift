import Foundation
import RxSwift
@testable import Makgulli

final class MockEpisodeDetailLocalRepository: EpisodeDetailLocalRepository {
    var deleteEpisodeResult: Completable = .empty()

    func deleteEpisode(id: String, episodeId: String) -> Completable {
        deleteEpisodeResult
    }
}
