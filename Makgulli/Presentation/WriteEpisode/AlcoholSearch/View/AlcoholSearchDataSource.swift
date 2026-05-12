//
//  AlcoholSearchDataSource.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

final class AlcoholSearchDataSource: UICollectionViewDiffableDataSource<AlcoholSearchSection, AlcoholSearchItem> {

    typealias Snapshot = NSDiffableDataSourceSnapshot<AlcoholSearchSection, AlcoholSearchItem>

    static let sectionHeaderElementKind = "AlcoholSearchSectionHeader"

    init(collectionView: UICollectionView) {
        let cellRegistration = UICollectionView.CellRegistration<AlcoholCell, AlcoholVO> { cell, _, alcohol in
            cell.configure(alcohol)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<AlcoholSectionHeaderView>(
            elementKind: Self.sectionHeaderElementKind
        ) { _, _, _ in }

        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .alcohol(let alcohol):
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: alcohol
                )
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
}
