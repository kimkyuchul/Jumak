//
//  TabBarCoordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/22/24.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    weak var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private var tabBarController = UITabBarController()
    
    private let dependency: injector
    
    init(
        navigationController: UINavigationController,
        dependency: injector
    ) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        // 탭 별 뷰컨트롤러 생성
        let viewControllers = TabBar.allCases.map {
            createTabNavigationController(of: $0)
        }
        
        // 탭바컨트롤러 설정
        configureTabbarController(with: viewControllers)
    }
}

extension TabBarCoordinator {
    private func configureTabbarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        
        self.tabBarController.tabBar.tintColor = .brown
        self.tabBarController.tabBar.unselectedItemTintColor = .darkGray
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont.boldLineSeed(size: ._12)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.brown, .font: UIFont.boldLineSeed(size: ._12)]
        self.tabBarController.tabBar.standardAppearance = appearance
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        navigationController.viewControllers = [tabBarController]
    }
    
    private func createTabNavigationController(of tabBar: TabBar) -> UINavigationController {
        let tabBarNavigationController = UINavigationController()
        tabBarNavigationController.tabBarItem = tabBar.tabBarItem
        setTabBarFlow(of: tabBar, to: tabBarNavigationController)
        return tabBarNavigationController
    }
    
    private func setTabBarFlow(of tabBar: TabBar, to tabNavigationController: UINavigationController) {
        switch tabBar {
        case .makgulli:
            let locationCoordinator = LocationCoordinator(navigationController: tabNavigationController, dependency: dependency)
            locationCoordinator.parentCoordinator = self
            locationCoordinator.start()
            
            addDependency(locationCoordinator)
            
            
        case .favorite:
            let favoriteCoordinator = FavoriteCoordinator(navigationController: tabNavigationController, dependency: dependency)
            favoriteCoordinator.parentCoordinator = self
            favoriteCoordinator.start()
             
            addDependency(favoriteCoordinator)
        }
    }
}
