//
//  RootHandler.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/23.
//

import UIKit

final class RootHandler {
    static let shard = RootHandler()
    
    enum Destination {
        case main
    }
    
    private init() {}
    
    func update(_ destination: Destination) {
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        switch destination {
        case .main:
            let mainViewController = TabBarController()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.transition(with: delegate.window!,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    delegate.window?.rootViewController = mainViewController
                    delegate.window?.makeKeyAndVisible()
                },
                                  completion: nil)
            }
        }
    }
}
