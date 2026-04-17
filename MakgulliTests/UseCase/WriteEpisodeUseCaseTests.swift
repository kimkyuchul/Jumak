import XCTest
import RxSwift
import RxBlocking
@testable import Makgulli

final class WriteEpisodeUseCaseTests: XCTestCase {

    private var sut: DefaultWriteEpisodeUseCase!
    private var mockRepository: MockWriteEpisodeRepository!
    private var mockLocalRepository: MockWriteEpisodeLocalRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWriteEpisodeRepository()
        mockLocalRepository = MockWriteEpisodeLocalRepository()
        sut = DefaultWriteEpisodeUseCase(
            writeEpisodeRepository: mockRepository,
            writeEpisodeLocalRepository: mockLocalRepository
        )
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockLocalRepository = nil
        super.tearDown()
    }

    // MARK: - updateEpisodeList

    func test_givenStoreNotExists_whenUpdateEpisodeList_thenCreatesStoreTable() {
        // Given
        mockLocalRepository.checkContainsStoreResult = false
        let store = StoreVOFactory.make()
        let episode = EpisodeVOFactory.make()
        let imageData = Data([0x00, 0x01])

        // When
        let result = sut.updateEpisodeList(store, episode: episode, imageData: imageData)
            .toBlocking(timeout: 1.0)
            .materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.createStoreTableCallCount, 1)
            XCTAssertEqual(mockLocalRepository.updateEpisodeCallCount, 0)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }

    func test_givenStoreExists_whenUpdateEpisodeList_thenUpdatesEpisode() {
        // Given
        mockLocalRepository.checkContainsStoreResult = true
        let store = StoreVOFactory.make()
        let episode = EpisodeVOFactory.make()
        let imageData = Data([0x00, 0x01])

        // When
        let result = sut.updateEpisodeList(store, episode: episode, imageData: imageData)
            .toBlocking(timeout: 1.0)
            .materialize()

        // Then
        switch result {
        case .completed:
            XCTAssertEqual(mockLocalRepository.updateEpisodeCallCount, 1)
            XCTAssertEqual(mockLocalRepository.createStoreTableCallCount, 0)
        case .failed:
            XCTFail("Expected completed but got failed")
        }
    }
}
