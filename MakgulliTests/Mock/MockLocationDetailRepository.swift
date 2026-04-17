import Foundation
@testable import Makgulli

final class MockLocationDetailRepository: LocationDetailRepository {
    var loadDataSourceImageResult: Data?

    func loadDataSourceImage(fileName: String) -> Data? {
        loadDataSourceImageResult
    }
}
