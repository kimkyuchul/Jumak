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
    static var touchMarker: UIImage { .load(named: "TouchMarker") }
    static var marker: UIImage { .load(named: "Marker") }
    
    //MARK: - Home
    
    //MARK: - Map
    
    //MARK: - Favorite
    
    //MARK: - System image
    static var checkIcon: UIImage { .load(systemName: "checkmark")}
    static var bookMarkIcon: UIImage { .load(systemName: "bookmark") }
    static var fillBookMarkIcon: UIImage { .load(systemName: "bookmark.fill") }
    static var rightCircleArrowIcon: UIImage { .load(systemName: "arrow.forward.circle") }
    static var mapQuestionIcon: UIImage { .load(systemName: "takeoutbag.and.cup.and.straw") }
    static var makgulliCategoryIcon: UIImage { .load(systemName: "bolt.heart.fill") }
    static var pajeonCategoryIcon: UIImage { .load(systemName: "cloud.sun.rain.fill") }
    static var bossamCategoryIcon: UIImage { .load(systemName: "frying.pan.fill") }
    static var koreaIcon: UIImage { .load(systemName: "k.circle.fill") }
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
