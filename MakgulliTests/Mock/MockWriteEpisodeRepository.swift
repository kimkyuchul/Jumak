import Foundation
import RxSwift
@testable import Makgulli

final class MockWriteEpisodeRepository: WriteEpisodeRepository {
    var saveImageResult: Completable = .empty()

    func saveImage(fileName: String, imageData: Data) -> Completable {
        saveImageResult
    }
}
