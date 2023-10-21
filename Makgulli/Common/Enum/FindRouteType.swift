//
//  FindRouteType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/21.
//

import UIKit

enum FindRouteType: CaseIterable {
    case naver
    case kakao
    case apple
    
    var title: String {
        switch self {
        case .naver:
            return "네이버 길찾기"
        case .kakao:
            return "카카오 길찾기"
        case .apple:
            return "애플 길찾기"
        }
    }
    
    var logoImage: UIImage {
        switch self {
        case .naver:
            return ImageLiteral.copyIcon
        case .kakao:
            return ImageLiteral.calendarIcon
        case .apple:
            return ImageLiteral.fillBookMarkIcon
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .naver:
            return UIColor.green
        case .kakao:
            return UIColor.yellow
        case .apple:
            return UIColor.blue
        }
    }
}
