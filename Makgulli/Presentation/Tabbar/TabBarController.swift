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
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

extension TabBarController {
    func setViewControllers() {
        let locationViewController = LocationViewController()
        locationViewController.tabBarItem = UITabBarItem(
            title: StringLiteral.location,
            image: ImageLiteral.koreaIcon,
            selectedImage: nil)
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem = UITabBarItem(
            title: StringLiteral.home,
            image: ImageLiteral.koreaIcon,
            selectedImage: nil)
        
        super.setViewControllers([
            locationViewController,
            homeViewController
        ], animated: true)
    }
}