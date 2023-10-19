//
//  FavoriteViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/30.
//

import UIKit

import RxSwift
import RxCocoa

final class FavoriteViewController: BaseViewController {
    
    enum FavoriteSection {
        case favorite
    }
    
    typealias SectionHeaderRegistration<Header: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<FilterHeaderView>
    typealias FavoriteCollectionViewCellRegistration = UICollectionView.CellRegistration<StoreCollectionViewCell, StoreVO>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, StoreVO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FavoriteSection, StoreVO>
    private var dataSource: DiffableDataSource?
    private let viewModel: FavoriteViewModel
    private let didSelectReverseFilterButton = PublishRelay<ReverseFilterType>()
    
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: "StoreCollectionViewCell")
        return collectionView
    }()
        
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .pink
        self.navigationController?.navigationBar.isHidden = true
        configureCellRegistrationAndDataSource()
        print(#function)
    }
    
    override func bind() {
        let input = FavoriteViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear.map { _ in },
                                            didSelectReverseFilterButton: didSelectReverseFilterButton.asObservable())
        let output = viewModel.transform(input: input)
                
        output.storeList
            .withUnretained(self)
            .bind(onNext: { owner, storeListAndFilterType in
                let (storeList, filterType, reverseFilterType) = storeListAndFilterType
                
                owner.applyCollectionViewDataSource(by: storeList, countTitle: storeList.count, filterType: filterType, reverseFilterType: reverseFilterType)
            })
            .disposed(by: disposeBag)
    }
    
    func applyCollectionViewDataSource(
        by viewModels: [StoreVO], countTitle: Int, filterType: FilterType, reverseFilterType: ReverseFilterType
    ) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.favorite])
        snapshot.appendItems(viewModels, toSection: .favorite)
        snapshot.reconfigureItems(viewModels)
        configureHeader(countTitle: countTitle, filterType: filterType, reverseFilter: reverseFilterType)
        
//        dataSource?.apply(snapshot, animatingDifferences: false)
        dataSource?.applySnapshotUsingReloadData(snapshot)
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
    
    private func configureHeader(countTitle: Int, filterType: FilterType, reverseFilter: ReverseFilterType) {
        let headerRegistration = SectionHeaderRegistration<FilterHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, _ ,_ in
            supplementaryView.configure(countTile: countTitle, filterType: filterType, reverseFilter: reverseFilter)
            supplementaryView.bottomSheetDelegate = self
            supplementaryView.filterReverseDelegate = self
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
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension FavoriteViewController: ShowFilterBottomSheetDelegate {
    func filterButtonTapped() {
        let navigationController = FilterBottomSheetViewController()
        present(navigationController, animated: true, completion: nil)
    }
}

extension FavoriteViewController: FilterReverseDelegate {
    func filterReverseButtonTapped(_ bool: Bool) {
        bool ? didSelectReverseFilterButton.accept(.reverse) : didSelectReverseFilterButton.accept(.none)
    }
}
