//
//  NotificationCenterHandler.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import Foundation
import RxSwift

protocol NotificationCenterHandler {
    var name: Notification.Name { get }
}

extension NotificationCenterHandler {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(name).map { $0.object }
    }

    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: nil)
    }
}

enum NotificationCenterManager: NotificationCenterHandler {
    case filterStore
    case reverseFilter

    var name: Notification.Name {
        switch self {
        case .filterStore:
            return Notification.Name("NotificationCenterManager.filterStore")
        case .reverseFilter:
            return Notification.Name("NotificationCenterManager.reverseFilter")
        }
    }
}
