//
//  LocationDetailUseCase.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/07.
//

import Foundation

import RxSwift

protocol LocationDetailUseCase: AnyObject {
    func syncStore(_ store: StoreVO) -> Completable
    func updateStoreEpisode(_ store: StoreVO) -> StoreVO?
    func loadEpisodeImage(_ fileName: String) -> Data?
}

final class DefaultLocationDetailUseCase: LocationDetailUseCase {
    enum LocationDetailError: Error {
        case createStore
        case updateStore
        case deleteStore
    }

    private let locationDetailRepository: LocationDetailRepository
    private let locationDetailLocalRepository: LocationDetailLocalRepository

    init(
        locationDetailRepository: LocationDetailRepository,
        locationDetailLocalRepository: LocationDetailLocalRepository
    ) {
        self.locationDetailRepository = locationDetailRepository
        self.locationDetailLocalRepository = locationDetailLocalRepository
    }

    func syncStore(_ store: StoreVO) -> Completable {
        let exists  = storeExists(store.id)
        let hasData = hasRatingOrEpisode(store)

        switch (exists, hasData) {
        case (false, false):
            // Realm에 없고 저장할 값도 없는 경우
            return .empty()

        case (false, true):
            // Realm에 존재하지 않으면서, 평점 또는 에피소드, 북마크 중 하나라도 존재하는 경우
            return locationDetailLocalRepository.createStore(store)
                .catch { _ in .error(LocationDetailError.createStore) }

        case (true, false):
            // Realm에 존재하는데, 평점, 에피소드, 북마크 모두 값이 없는 경우
            return locationDetailLocalRepository.deleteStore(store)
                .catch { _ in .error(LocationDetailError.deleteStore) }

        case (true, true):
            // Realm에 존재하고 저장할 값도 있는 경우 — 변경사항이 있을 때만 update
            guard shouldUpdateStore(store) else { return .empty() }
            return locationDetailLocalRepository.updateStore(store)
                .catch { _ in .error(LocationDetailError.updateStore) }
        }
    }

    func updateStoreEpisode(_ store: StoreVO) -> StoreVO? {
        locationDetailLocalRepository.updateStoreEpisode(store)
    }

    func loadEpisodeImage(_ fileName: String) -> Data? {
        locationDetailRepository.loadDataSourceImage(fileName: fileName)
    }
}

extension DefaultLocationDetailUseCase {
    private func storeExists(_ id: String) -> Bool {
        locationDetailLocalRepository.checkContainsStore(id)
    }

    private func shouldUpdateStore(_ store: StoreVO) -> Bool {
        locationDetailLocalRepository.shouldUpdateStore(store)
    }

    private func hasRatingOrEpisode(_ store: StoreVO) -> Bool {
        store.rate > 0 || !store.episode.isEmpty || store.bookmark
    }
}
