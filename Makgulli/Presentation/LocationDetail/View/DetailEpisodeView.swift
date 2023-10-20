//
//  DetailEpisodeView.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/06.
//

import UIKit

import RxSwift

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
        label.font = UIFont.boldLineSeed(size: ._18)
        return label
    }()
    lazy var episodeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createEpisodeLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionViewCell")
        return collectionView
    }()
    fileprivate let episodeEmptyView = EpisodeEmptyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        configureCellRegistrationAndDataSource()
    }
    
    private func configureCellRegistrationAndDataSource() {
        let registration = EpisodeCollectionViewCellRegistration { cell, indexPath, episode in
            cell.configureCell(item: episode, episodeIndex: indexPath.item + 1)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: episodeCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func createEpisodeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { (visibleItems, offset, env) in
            visibleItems.forEach { item in
                let intersectedRect = item.frame.intersection(CGRect(x: offset.x, y: offset.y, width: env.container.contentSize.width, height: item.frame.height))
                let percentVisible = intersectedRect.width / item.frame.width
                let scale = 0.8 + (0.2 * percentVisible)
                item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
            }
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    override func setHierarchy() {
        [episodeTitleLabel, episodeCollectionView, episodeEmptyView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        episodeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().offset(-42)
        }
        
        episodeEmptyView.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(episodeCollectionView.snp.height)
            make.bottom.equalToSuperview()
        }
    }
}

extension Reactive where Base: DetailEpisodeView {
    var handleEpisodeEmptyViewVisibility: Binder<Bool> {
        return Binder(self.base) { view, isHidden in
            view.episodeEmptyView.isHidden = isHidden
        }
    }
}

