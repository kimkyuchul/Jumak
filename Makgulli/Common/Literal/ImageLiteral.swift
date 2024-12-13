//
//  ImageLiteral.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import UIKit

enum ImageLiteral {
    
    //MARK: - logo icon
    static var touchMarker: UIImage { .load(named: "TouchMarker") }
    static var marker: UIImage { .load(named: "Marker") }
    
    //MARK: - Map
    static var makgulliLogo: UIImage { .load(named: "Makgulli") }
    static var pajeonLogo: UIImage { .load(named: "Pajeon") }
    static var bossamLogo: UIImage { .load(named: "bossam") }
    static var makgulliImage: UIImage { .load(named: "RealMakgulli") }
    
    //MARK: - Favorite
    
    //MARK: - System image
    static var back: UIImage { .load(systemName: "chevron.backward") }
    static var checkIcon: UIImage { .load(systemName: "checkmark")}
    static var bookMarkIcon: UIImage { .load(systemName: "bookmark") }
    static var fillBookMarkIcon: UIImage { .load(systemName: "bookmark.fill") }
    static var rightCircleArrowIcon: UIImage { .load(systemName: "arrow.forward.circle") }
    static var reSearchArrowIcon: UIImage { .load(systemName: "arrow.counterclockwise") }
    static var userLocationIcon: UIImage { .load(systemName: "scope") }
    static var mapQuestionIcon: UIImage { .load(systemName: "takeoutbag.and.cup.and.straw") }
    static var boltHeartFillIcon: UIImage { .load(systemName: "bolt.heart.fill") }
    static var boltHeartIcon: UIImage { .load(systemName: "bolt.heart") }
    static var pajeonCategoryIcon: UIImage { .load(systemName: "cloud.sun.rain.fill") }
    static var bossamCategoryIcon: UIImage { .load(systemName: "frying.pan.fill") }
    static var koreaIcon: UIImage { .load(systemName: "k.circle.fill") }
    static var storeEmptyIcon: UIImage { .load(systemName: "location.slash.fill") }
    static var storeLocationIcon: UIImage { .load(systemName: "location.circle") }
    static var starIcon: UIImage { .load(systemName: "star") }
    static var starCircleIcon: UIImage { .load(systemName: "star.circle") }
    static var fillStarIcon: UIImage { .load(systemName: "star.fill") }
    static var mapIcon: UIImage { .load(systemName: "map") }
    static var copyIcon : UIImage { .load(systemName: "doc.on.doc") }
    static var swifeArrowIcon : UIImage { .load(systemName: "cursorarrow.motionlines") }
    static var circleHeart : UIImage { .load(systemName: "heart.circle") }
    static var heartIcon : UIImage { .load(systemName: "heart") }
    static var fillHeartIcon : UIImage { .load(systemName: "heart.fill") }
    static var xmarkIcon : UIImage { .load(systemName: "xmark") }
    static var calendarIcon : UIImage { .load(systemName: "calendar.badge.plus") }
    static var cameraIcon : UIImage { .load(systemName: "camera") }
    static var plusIcon : UIImage { .load(systemName: "plus") }
    static var minusIcon : UIImage { .load(systemName: "minus") }
    static var arrowDownIcon : UIImage { .load(systemName: "chevron.down") }
    static var episodeDefaultImage : UIImage { .load(systemName: "party.popper.fill") }
    static var deleteEpisodeIcon : UIImage { .load(systemName: "trash.fill") }
    static var titleArrowDownIcon : UIImage { .load(systemName: "arrowtriangle.down.circle") }
    static var networkErrorIcon : UIImage { .load(systemName: "network") }
    static var reserveFilterIcon : UIImage { .load(systemName: "arrow.up.arrow.down") }
    static var settingIcon : UIImage { .load(systemName: "gearshape.fill") }
    static var mapTabIcon: UIImage { .load(systemName: "magnifyingglass") }
    static var warningIcon: UIImage { .load(systemName: "checkmark.circle.trianglebadge.exclamationmark") }
    static var wineglassIcon: UIImage { .load(systemName: "wineglass") }
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
