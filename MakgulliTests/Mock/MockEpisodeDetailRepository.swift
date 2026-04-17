import Foundation
import RxSwift
@testable import Makgulli

final class MockEpisodeDetailRepository: EpisodeDetailRepository {
    var removeImageResult: Completable = .empty()

    func removeImage(fileName: String) -> Completable {
        removeImageResult
    }
}
