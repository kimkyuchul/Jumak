//
//  TabBar.swift
//  Makgulli
//
//  Created by kyuchul on 11/23/24.
//

import UIKit

enum TabBar: CaseIterable {
    case makgulli
    case favorite
    case alcoholicBeverage
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .makgulli:
            return makeTabBarItem(title: StringLiteral.location, image: ImageLiteral.mapTabIcon)
            
        case .favorite:
            return makeTabBarItem(title: StringLiteral.Favorite, image: ImageLiteral.heartIcon)
            
        case .alcoholicBeverage:
            return makeTabBarItem(title: StringLiteral.alcoholicBeverage, image: ImageLiteral.wineglassIcon)
        }
    }
}

private extension TabBar {
    func makeTabBarItem(title: String, image: UIImage) -> UITabBarItem {
        return UITabBarItem(title: title, image: image, selectedImage: nil)
    }
}
