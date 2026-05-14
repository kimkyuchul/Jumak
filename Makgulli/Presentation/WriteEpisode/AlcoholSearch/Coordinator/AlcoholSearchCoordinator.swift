//
//  AlcoholSearchCoordinator.swift
//  Makgulli
//
//  Created by 김규철 on 5/12/26.
//

import UIKit

final class AlcoholSearchCoordinator: Coordinator {
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    var onSelect: ((AlcoholVO) -> Void)?

    private let dependency: injector

    init(
        navigationController: UINavigationController,
        dependency: injector
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
    }

    deinit {
        debugPrint("deinit Coordinator: \(self)")
    }

    func start() {
        let viewModel = dependency
            .makeSearchAlcoholDIContainer()
            .makeAlcoholSearchViewModel()
        viewModel.coordinator = self

        let viewController = AlcoholSearchViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen

        let presenter = navigationController.presentedViewController ?? navigationController
        presenter.present(viewController, animated: true)
    }
}

extension AlcoholSearchCoordinator {
    func dismissAlcoholSearch() {
        parentCoordinator?.removeDependency(self)
        navigationController.presentedViewController?.dismiss(animated: true)
    }

    func selectAlcohol(_ alcohol: AlcoholVO) {
        onSelect?(alcohol)
        dismissAlcoholSearch()
    }
}
