//
//  ImageLiteral.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit

enum ImageLiteral {
    
    // MARK: - tab bar icon
    static var homeIcon: UIImage { .load(named: "homeIcon") }
    
    //MARK: - logo icon
    static var makgulliLogo: UIImage { .load(named: "makgulliLogo") }
    
    //MARK: - Home
    
    //MARK: - Map
    
    //MARK: - Favorite
    
    //MARK: - System image
    static var checkIcon: UIImage { .load(systemName: "checkmark")}
    static var bookMarkIcon: UIImage { .load(systemName: "bookmark") }
    static var fillBookMarkIcon: UIImage { .load(systemName: "bookmark.fill") }
}

extension UIImage {
    
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
}