//
//  AlcoholSearchViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2026/05/11.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class AlcoholSearchViewController: BaseViewController {
    private let viewModel: AlcoholSearchViewModel

    private let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark") ?? UIImage()
        button.setImage(image, for: .normal)
        button.tintColor = .deepDarkGray
        return button
    }()

    private let layoutToggleButton: UIButton = {
        let button = UIButton()
        button.tintColor = .deepDarkGray
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "술 검색"
        label.font = UIFont.boldLineSeed(size: ._18)
        label.textColor = .black
        return label
    }()

    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout(for: .grid))
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private lazy var indicatorView = IndicatorView()

    private var dataSource: AlcoholSearchDataSource?
    private var currentMode: AlcoholSearchLayoutMode = .grid

    init(viewModel: AlcoholSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = AlcoholSearchDataSource(collectionView: collectionView)
        collectionView.prefetchDataSource = dataSource
    }

    override func setHierarchy() {
        [navigationBar, collectionView, indicatorView].forEach {
            view.addSubview($0)
        }
        [titleLabel, layoutToggleButton, closeButton].forEach {
            navigationBar.addSubview($0)
        }
    }

    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }

        layoutToggleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setLayout() {
        view.backgroundColor = .white
    }

    override func bind() {
        let didSelectAlcohol = collectionView.rx.itemSelected
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .compactMap { [weak self] indexPath -> AlcoholVO? in
                guard let item = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
                if case .alcohol(let alcohol) = item { return alcohol }
                return nil
            }

        let input = AlcoholSearchViewModel.Input(
            viewDidLoadEvent: self.rx.viewWillAppear.map { _ in },
            willDisplayCell: collectionView.rx.willDisplayCell.map { $0.at },
            didTapCloseButton: closeButton.rx.tap.throttle(.milliseconds(300), scheduler: MainScheduler.instance).asObservable(),
            didTapLayoutToggle: layoutToggleButton.rx.tap.throttle(.milliseconds(300), scheduler: MainScheduler.instance).asObservable(),
            didSelectAlcohol: didSelectAlcohol
        )
        let output = viewModel.transform(input: input)

        output.snapshot
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, sections in
                owner.dataSource?.reload(sections)
            }
            .disposed(by: disposeBag)

        let layoutMode = output.layoutMode.asDriver()

        layoutMode
            .map { UIImage(systemName: $0 == .grid ? "list.bullet" : "square.grid.2x2") }
            .drive(with: self) { owner, image in
                owner.layoutToggleButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)

        layoutMode
            .drive(with: self) { owner, mode in
                owner.applyLayoutMode(mode)
            }
            .disposed(by: disposeBag)

        collectionView.rx.willDisplayCell
            .asDriver()
            .drive(onNext: { cell, _ in
                cell.alpha = 0
                cell.transform = CGAffineTransform(translationX: 0, y: 12)
                UIView.animate(
                    withDuration: 0.35,
                    delay: 0,
                    usingSpringWithDamping: 0.9,
                    initialSpringVelocity: 0.4,
                    options: [.curveEaseOut, .allowUserInteraction]
                ) {
                    cell.alpha = 1
                    cell.transform = .identity
                }
            })
            .disposed(by: disposeBag)

        output.isLoading
            .asDriver()
            .drive(indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        output.showErrorAlert
            .asSignal()
            .flatMapFirst { [weak self] _ -> Signal<Void> in
                guard let self else { return .empty() }
                return self.rx.makeErrorAlert(
                    title: "내부 에러",
                    message: "알 수 없는 에러가 발생했습니다.",
                    cancelButtonTitle: "확인"
                )
                .asSignal(onErrorSignalWith: .empty())
            }
            .emit()
            .disposed(by: disposeBag)
    }

    private func applyLayoutMode(_ mode: AlcoholSearchLayoutMode) {
        guard currentMode != mode else { return }
        currentMode = mode
        let newLayout = createLayout(for: mode)
        dataSource?.setMode(mode) { [weak self] in
            self?.collectionView.setCollectionViewLayout(newLayout, animated: false)
        }
    }

    private func createLayout(for mode: AlcoholSearchLayoutMode) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            switch mode {
            case .grid:
                return Self.makeGridSection()
            case .list:
                return Self.makeListSection()
            }
        }
    }

    private static func makeGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 12, leading: 16, bottom: 20, trailing: 16)
        section.supplementariesFollowContentInsets = false
        section.boundarySupplementaryItems = [stickyHeader()]
        return section
    }

    private static func makeListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(140)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(140)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero
        section.supplementariesFollowContentInsets = false
        section.boundarySupplementaryItems = [stickyHeader()]
        return section
    }

    private static func stickyHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: AlcoholSearchDataSource.sectionHeaderElementKind,
            alignment: .top
        )
        header.pinToVisibleBounds = true
        header.zIndex = 2
        return header
    }
}
