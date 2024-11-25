//
//  SettingDIContainer.swift
//  Makgulli
//
//  Created by kyuchul on 11/25/24.
//

import Foundation

final class AppInfoDIContainer {
    // MARK: - ViewModel
    func makeAppInfoViewModel() -> AppInfoViewModel {
        AppInfoViewModel()
    }
}
