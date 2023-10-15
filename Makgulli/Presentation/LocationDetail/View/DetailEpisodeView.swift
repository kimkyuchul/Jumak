//
//  DetailEpisodeView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/06.
//

import UIKit

final class DetailEpisodeView: BaseView {
    
    enum EpisodeSection {
        case episode
    }
        
    typealias EpisodeCollectionViewCellRegistration = UICollectionView.CellRegistration<EpisodeCollectionViewCell, Episode>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<EpisodeSection, Episode>
    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodeSection, Episode>
    var dataSource: DiffableDataSource?
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "에피소드 정보"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldLineSeed(size: ._20)
        return label
    }()
    lazy var episodeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createEpisodeLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureCellRegistrationAndDataSource()
    }
    
    private func configureCellRegistrationAndDataSource() {
        let registration = EpisodeCollectionViewCellRegistration { cell, _, episode in
            cell.configureCell(item: episode)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: episodeCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func createEpisodeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in
            visibleItems.forEach { item in
                let intersectedRect = item.frame.intersection(CGRect(x: offset.x, y: offset.y, width: env.container.contentSize.width, height: item.frame.height))
                let percentVisible = intersectedRect.width / item.frame.width
                let scale = 0.7 + (0.3 * percentVisible)
                item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
            }
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    override func setHierarchy() {
        [episodeTitleLabel, episodeCollectionView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        episodeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(120)
        }
    }
}

