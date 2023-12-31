//
//  TabBarController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/30.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        self.tabBar.tintColor = .brown
        self.tabBar.unselectedItemTintColor = .darkGray
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray, .font: UIFont.boldLineSeed(size: ._12)]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.brown, .font: UIFont.boldLineSeed(size: ._12)]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension TabBarController {
    func setViewControllers() {
        let locationViewController = UINavigationController(
            rootViewController: LocationViewController(
                viewModel: AppDIContainer.shared
                    .makeLocationDIContainer()
                    .makeLocationViewModel())
        )
        
        locationViewController.tabBarItem = UITabBarItem(
            title: StringLiteral.location,
            image: ImageLiteral.mapTabIcon,
            selectedImage: nil)
        
        let favoriteViewController = UINavigationController(
            rootViewController: FavoriteViewController(
                viewModel: AppDIContainer.shared
                    .makeFavoriteDIContainer()
                    .makeFavoriteViewModel())
        )
        
        favoriteViewController.tabBarItem = UITabBarItem(
            title: StringLiteral.Favorite,
            image: ImageLiteral.heartIcon,
            selectedImage: nil)
        
        super.setViewControllers([
            locationViewController,
            favoriteViewController
        ], animated: true)
    }
}
