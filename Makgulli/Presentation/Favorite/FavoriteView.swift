//
//  FavoriteView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/17.
//

import UIKit

import RxSwift
import RxCocoa

final class FavoriteView: BaseView {
    
    enum FavoriteSection {
        case favorite
    }
    
    typealias SectionHeaderRegistration<Header: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<FilterHeaderView>
    typealias FavoriteCollectionViewCellRegistration = UICollectionView.CellRegistration<StoreCollectionViewCell, StoreVO>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, StoreVO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FavoriteSection, StoreVO>
    var dataSource: DiffableDataSource?
    
    private var store: [Int: StoreVO] = .init()
    
    private let categoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .small
        let attributedTitle = NSAttributedString(string: "막걸리 찾기",
                                                 attributes: [
                                                    .font: UIFont.boldLineSeed(size: ._18),
                                                    .foregroundColor: UIColor.black
                                                 ])
        configuration.attributedTitle = AttributedString(attributedTitle)
        configuration.image = ImageLiteral.titleArrowDownIcon
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 6
        configuration.imagePlacement = .trailing
        let button = UIButton()
        button.configuration = configuration
        button.backgroundColor = .clear
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: "StoreCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellRegistrationAndDataSource()
    }
    
    func applyCollectionViewDataSource(
        by viewModels: [StoreVO], countTitle: Int
    ) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.favorite])
        snapshot.appendItems(viewModels, toSection: .favorite)
        snapshot.reconfigureItems(viewModels)
        configureHeader(countTitle: countTitle)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
//        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    private func configureCellRegistrationAndDataSource() {
        let registration = FavoriteCollectionViewCellRegistration { cell, _, episode in
            cell.configureCell(item: episode)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func configureHeader(countTitle: Int) {
        let headerRegistration = SectionHeaderRegistration<FilterHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, _ ,_ in
            supplementaryView.configure(countTile: countTitle)
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] _, _, indexPath in
            let header = self?.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            return header
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerSupplementary.pinToVisibleBounds = true
        
        section.boundarySupplementaryItems = [headerSupplementary]
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 6, leading: 10, bottom: 6, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .vertical
        
        return layout
    }
    
    override func setHierarchy() {
        [categoryButton, collectionView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
