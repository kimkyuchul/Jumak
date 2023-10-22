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
    typealias FavoriteCollectionViewCellRegistration = UICollectionView.CellRegistration<FilterCollectionViewCell, StoreVO>
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, StoreVO>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FavoriteSection, StoreVO>
    private var dataSource: DiffableDataSource?
    private let viewModel: FavoriteViewModel
    private let didSelectReverseFilterButton = PublishRelay<Void>()
    
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
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCollectionViewCell")
        return collectionView
    }()
    private lazy var indicatorView = IndicatorView(frame: .zero)
        
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .pink
        configureCellRegistrationAndDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func bind() {
        let input = FavoriteViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear.map { _ in },
                                            didSelectReverseFilterButton: didSelectReverseFilterButton.asObservable(), viewDidAppearEvent: self.rx.viewDidAppear.map { _ in })
        let output = viewModel.transform(input: input)
                
        output.storeList
            .withUnretained(self)
            .bind(onNext: { owner, storeListAndFilterType in
                let (storeList, filterType, reverseFilterType) = storeListAndFilterType
            
                owner.applyCollectionViewDataSource(by: storeList, countTitle: storeList.count, filterType: filterType, reverseFilterType: reverseFilterType)
            })
            .disposed(by: disposeBag)
        
        output.isLoding
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        collectionView.rx.itemSelected
            .withUnretained(self)
             .subscribe(onNext: { owner, indexPath in
                 guard let storeVO = owner.itemIdentifier(for: indexPath) else { return }
                 
                 guard let realmRepository = DefaultRealmRepository() else { return }
                 let detailVC = LocationDetailViewController(viewModel: LocationDetailViewModel(storeVO: storeVO, locationDetailUseCase: LocationDetailUseCase(realmRepository: realmRepository, locationDetailRepository: DefaultLocationDetailRepository(imageStorage: DefaultImageStorage(fileManager: FileManager())), urlSchemaService: DefaultURLSchemaService(), pasteboardService: DefaultPasteboardService())))
                     detailVC.hidesBottomBarWhenPushed = true
                     owner.navigationController?.pushViewController(detailVC, animated: true)
             })
             .disposed(by: disposeBag)
    }
    
    private func applyCollectionViewDataSource(
        by viewModels: [StoreVO], countTitle: Int, filterType: FilterType, reverseFilterType: Bool
    ) {
        print(#function)
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.favorite])
        snapshot.appendItems(viewModels, toSection: .favorite)
        snapshot.reconfigureItems(viewModels)
        configureHeader(countTitle: countTitle, filterType: filterType, reverseFilter: reverseFilterType)
        
//        dataSource?.apply(snapshot, animatingDifferences: false)
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    private func itemIdentifier(for indexPath: IndexPath) -> StoreVO? {
        return dataSource?.itemIdentifier(for: indexPath)
    }
    
    private func configureCellRegistrationAndDataSource() {
        let registration = FavoriteCollectionViewCellRegistration { cell, _, store in
            cell.configureCell(item: store)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func configureHeader(countTitle: Int, filterType: FilterType, reverseFilter: Bool) {
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
        section.contentInsets = .init(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration.scrollDirection = .vertical
        
        return layout
    }
    
    override func setHierarchy() {
        [categoryButton, collectionView, indicatorView].forEach {
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
        
        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    func filterReverseButtonTapped(_ void: Void) {
        self.didSelectReverseFilterButton.accept(void)
    }
}
