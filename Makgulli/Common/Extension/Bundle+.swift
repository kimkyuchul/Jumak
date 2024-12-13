//
//  Bundle+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/25.
//

import Foundation

extension Bundle {
    var naverMapsClientID: String {
        fetchAPIKey(fromPlist: "NaverMaps", withKey: "NMFClientId")
    }
    
    var kakaoAPIKey: String {
        fetchAPIKey(fromPlist: "KakaoAPIKey", withKey: "APIKey")
    }
    
    var openDataPortalServiceKey: String {
        fetchAPIKey(fromPlist: "OpenDataPortal", withKey: "ServiceKey")
    }
}

extension Bundle {
    var appVersion: String {
        guard let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return version
    }
}

private extension Bundle {
    private func fetchAPIKey(fromPlist fileName: String, withKey key: String) -> String {
        guard let file = self.path(forResource: fileName, ofType: "plist") else {
            fatalError("\(fileName).plist 파일이 없습니다.")
        }
        guard let resource = NSDictionary(contentsOfFile: file) else {
            fatalError("파일 형식 에러")
        }
        guard let value = resource[key] as? String else {
            fatalError("\(fileName)에 \(key)을 설정해주세요.")
        }
        return value
    }
}

