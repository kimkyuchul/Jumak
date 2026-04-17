import XCTest
import RxSwift
import RxBlocking
@testable import Makgulli

final class EpisodeDetailUseCaseTests: XCTestCase {

    private var sut: DefaultEpisodeDetailUseCase!
    private var mockRepository: MockEpisodeDetailRepository!
    private var mockLocalRepository: MockEpisodeDetailLocalRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockEpisodeDetailRepository()
        mockLocalRepository = MockEpisodeDetailLocalRepository()
        sut = DefaultEpisodeDetailUseCase(
            episodeDetailRepository: mockRepository,
            episodeDetailLocalRepository: mockLocalRepository
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockLocalRepository = nil
        super.tearDown()
    }

    // MARK: - deleteEpisode

    func test_givenBothSucceed_whenDeleteEpisode_thenCompletes() {
        // Given
        mockLocalRepository.deleteEpisodeResult = .empty()
        mockRepository.removeImageResult = .empty()

        // When
        let result = sut.deleteEpisode(storeId: "store-001", episodeId: "ep-001", imageFileName: "ep-001.jpg")
            .toBlocking(timeout: 1.0)
            .materialize()

        // Then
        switch result {
        case .completed:
            break
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }

    func test_givenRealmDeleteFails_whenDeleteEpisode_thenFailsWithDeleteEpisodeError() {
        // Given
        mockLocalRepository.deleteEpisodeResult = .error(NSError(domain: "test", code: -1))
        mockRepository.removeImageResult = .empty()

        // When
        let result = sut.deleteEpisode(storeId: "store-001", episodeId: "ep-001", imageFileName: "ep-001.jpg")
            .toBlocking(timeout: 1.0)
            .materialize()

        // Then
        switch result {
        case .completed:
            XCTFail("Expected failed but got completed")
        case .failed(_, let error):
            XCTAssertTrue(error is DefaultEpisodeDetailUseCase.EpisodeDetailError)
        }
    }
}
