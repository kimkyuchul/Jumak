import Foundation
import RxSwift
@testable import Makgulli

final class MockSearchLocationRepository: SearchLocationRepository {
    var fetchLocationResult: Single<SearchLocationVO> = .never()

    func fetchLocation(query: String, x: String, y: String, page: Int, display: Int) -> Single<SearchLocationVO> {
        fetchLocationResult
    }
}
