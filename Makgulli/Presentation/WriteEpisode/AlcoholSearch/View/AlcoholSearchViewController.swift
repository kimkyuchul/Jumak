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
        button.tintColor = .darkGray
        return button
    }()

    private lazy var navigationBar: JumakNavigationBar = {
        let bar = JumakNavigationBar(rightItems: [closeButton])
        bar.backgroundColor = .lightGray
        return bar
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .lightGray
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private lazy var indicatorView = IndicatorView(frame: .zero)

    private var dataSource: AlcoholSearchDataSource?

    init(viewModel: AlcoholSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = AlcoholSearchDataSource(collectionView: collectionView)
    }

    override func setHierarchy() {
        [navigationBar, collectionView, indicatorView].forEach {
            view.addSubview($0)
        }
    }

    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
        view.backgroundColor = .lightGray
    }

    override func bind() {
        let input = AlcoholSearchViewModel.Input(
            viewDidLoadEvent: self.rx.viewDidAppear.map { _ in },
            willDisplayCell: collectionView.rx.willDisplayCell.map { $0.at },
            didTapCloseButton: closeButton.rx.tap.throttle(.milliseconds(300), scheduler: MainScheduler.instance).asObservable()
        )
        let output = viewModel.transform(input: input)

        output.snapshot
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, sections in
                owner.dataSource?.reload(sections)
            }
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

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(76)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(76)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = .init(top: 8, leading: 16, bottom: 16, trailing: 16)

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(36)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: AlcoholSearchDataSource.sectionHeaderElementKind,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
}
