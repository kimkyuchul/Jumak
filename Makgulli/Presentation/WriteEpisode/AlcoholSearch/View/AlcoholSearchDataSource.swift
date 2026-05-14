//
//  AlcoholSearchDataSource.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

import KCImageCache

final class AlcoholSearchDataSource: UICollectionViewDiffableDataSource<AlcoholSearchSection, AlcoholSearchItem> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<AlcoholSearchSection, AlcoholSearchItem>

    static let sectionHeaderElementKind = "AlcoholSearchSectionHeader"

    private var mode: AlcoholSearchLayoutMode = .grid
    private let prefetcher = KCImagePrefetcher()

    init(collectionView: UICollectionView) {
        let gridRegistration = UICollectionView.CellRegistration<AlcoholCell, AlcoholVO> { [weak collectionView] cell, _, alcohol in
            guard let collectionView else { return }
            cell.configure(alcohol, thumbnailSize: Self.gridThumbnailSize(in: collectionView))
        }

        let listRegistration = UICollectionView.CellRegistration<AlcoholListCell, AlcoholVO> { cell, _, alcohol in
            cell.configure(alcohol)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<AlcoholSectionHeaderView>(
            elementKind: Self.sectionHeaderElementKind
        ) { _, _, _ in }

        super.init(collectionView: collectionView) { [weak collectionView] _, indexPath, item in
            guard let collectionView else { return nil }
            switch item {
            case .alcohol(let alcohol):
                let dataSource = collectionView.dataSource as? AlcoholSearchDataSource
                switch dataSource?.mode ?? .grid {
                case .grid:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: gridRegistration,
                        for: indexPath,
                        item: alcohol
                    )
                case .list:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: listRegistration,
                        for: indexPath,
                        item: alcohol
                    )
                }
            }
        }

        supplementaryViewProvider = { [weak self] collectionView, _, indexPath in
            let view = collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            if let section = self?.snapshot().sectionIdentifiers[safe: indexPath.section] {
                view.configure(letter: section.letter)
            }
            return view
        }
    }

    func reload(_ sections: [AlcoholSearchSection]) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        apply(snapshot, animatingDifferences: false)
    }

    func setMode(_ mode: AlcoholSearchLayoutMode, completion: (() -> Void)? = nil) {
        guard self.mode != mode else {
            completion?()
            return
        }
        self.mode = mode
        var snapshot = self.snapshot()
        snapshot.reloadItems(snapshot.itemIdentifiers)
        apply(snapshot, animatingDifferences: false, completion: completion)
    }
    
    private static func gridThumbnailSize(in collectionView: UICollectionView) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 16 - 16 - 12) / 2
        return CGSize(width: cellWidth, height: cellWidth * 5.0 / 4.0)
    }
}

extension AlcoholSearchDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetcher.prefetchImage(imageRequests(at: indexPaths))
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        prefetcher.cancelTask(imageRequests(at: indexPaths))
    }

    private func imageRequests(at indexPaths: [IndexPath]) -> [ImageRequest] {
        indexPaths.compactMap { indexPath in
            guard case .alcohol(let alcohol) = itemIdentifier(for: indexPath),
                  let url = URL(string: alcohol.thumbnailURL) else { return nil }
            return ImageRequest(url: url)
        }
    }
}
