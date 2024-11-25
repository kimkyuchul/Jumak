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
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .makgulli:
            return UITabBarItem(
                title: StringLiteral.location,
                image: ImageLiteral.mapTabIcon,
                selectedImage: nil
            )
            
        case .favorite:
            return UITabBarItem(
                title: StringLiteral.Favorite,
                image: ImageLiteral.heartIcon,
                selectedImage: nil
            )
        }
    }
}
