//
//  URLSchemaService.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/21.
//

import UIKit

protocol URLSchemaService: AnyObject {
    func openMapForURL(findRouteType: FindRouteType, locationCoordinate: (Double, Double), address: String)
}

final class DefaultURLSchemaService: URLSchemaService {
    
    private let shared = UIApplication.shared
    
    func openMapForURL(findRouteType: FindRouteType, locationCoordinate: (Double, Double), address: String) {
        var url: URL?
        var appStoreURL: URL?
        
        switch findRouteType {
        case .naver:
            let appBundleID = Bundle.main.bundleIdentifier ?? ""
            let naverURLString = "nmap://route/car?dlat=\(locationCoordinate.0)&dlng=\(locationCoordinate.1)&appname=\(appBundleID)"
            url = URL(string: naverURLString)
            appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")
        case .kakao:
            let kakaoURLString = "kakaomap://route?ep=\(locationCoordinate.0),\(locationCoordinate.1)&by=CAR"
            url = URL(string: kakaoURLString)
            appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id304608425")
        case .apple:
            let appleURLString = "maps://?daddr=\(address)&dirfgl=d"
            if let encodedStr = appleURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url = URL(string: encodedStr)
                appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id915056765")
            }
        }
        
        showRouteInMap(findRouteType, url, appStoreURL)
    }
    
    private func showRouteInMap(_ findRouteType: FindRouteType, _ url: URL?, _ appStoreURL: URL?) {
        guard let url = url, let appStoreURL = appStoreURL  else {
            dump("Map URL Error")
            return
        }
        
        if findRouteType == .kakao {
            showKakaoMap(url, appStoreURL)
            return
        }
        
        if shared.canOpenURL(url) {
            shared.open(url)
        } else {
            shared.open(appStoreURL)
        }
    }
    
    private func showKakaoMap(_ url: URL, _ appStoreURL: URL) {
        let urlString = "kakaomap://open"
        
        if let appUrl = URL(string: urlString) {
            if shared.canOpenURL(appUrl) {
                shared.open(url)
            } else {
                shared.open(appStoreURL)
            }
        }
    }
}

