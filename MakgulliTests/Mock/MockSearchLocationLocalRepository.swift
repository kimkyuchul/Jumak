import Foundation
import RxSwift
@testable import Makgulli

final class MockSearchLocationLocalRepository: SearchLocationLocalRepository {
    var updateWillDisplayResult: Single<StoreVO> = .never()
    var updateStoreCellResult: StoreVO?

    func updateWillDisplayStoreCell(index: Int, storeList: [StoreVO]) -> Single<StoreVO> {
        updateWillDisplayResult
    }

    func updateStoreCell(store: StoreVO) -> StoreVO? {
        updateStoreCellResult
    }
}
