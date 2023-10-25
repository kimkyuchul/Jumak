//
//  Bundle+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import Foundation

extension Bundle {
    var naverMapsClientID: String {
        guard let file = self.path(forResource: "NaverMaps", ofType: "plist") else {
            fatalError("NaverMaps.plist 파일이 없습니다.")
        }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let clientID = resource["NMFClientId"] as? String else {
            fatalError("NaverMaps에 NMFClientId을 설정해주세요.")
        }
        return clientID
    }
    
    var kakaoAPIKey: String {
        guard let file = self.path(forResource: "KakaoAPIKey", ofType: "plist") else {
            fatalError("KakaoAPIKey.plist 파일이 없습니다.")
        }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let clientID = resource["APIKey"] as? String else {
            fatalError("KakaoAPIKey에 APIKey을 설정해주세요.")
        }
        return clientID
    }
    
    var appVersion: String {
            guard
                let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            else {
                return ""
            }
            return version
        }
}
