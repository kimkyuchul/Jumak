//
//  AppInfoType.swift
//  Makgulli
//
//  Created by kyuchul on 11/25/24.
//

import Foundation

enum AppInfoType: CaseIterable, CustomStringConvertible {
    case appInfo
    
    var contents: [AppInfoSection] {
        switch self {
        case .appInfo:
            return [.inquiry, .privacyPolicy, .openSourceInfo, .versionInfo]
        }
    }
    
    var description: String {
        switch self {
        case .appInfo:
            return "앱 정보"
        }
    }
}

enum AppInfoSection: String, CustomStringConvertible {
    case inquiry = "문의하기"
    case privacyPolicy = "개인정보 처리방침"
    case openSourceInfo = "오픈소스 사용정보"
    case versionInfo = "버전정보"
    
    var description: String {
        return self.rawValue
    }
}
