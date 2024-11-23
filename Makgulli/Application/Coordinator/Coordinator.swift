//
//  Coordinator.swift
//  Makgulli
//
//  Created by kyuchul on 11/22/24.
//

import UIKit

protocol Coordinatable {
    associatedtype CoordinatorType: Coordinator
    
    var coordinator: CoordinatorType? { get }
}

protocol Coordinator: AnyObject {
    // 부모 코디네이터
    var parentCoordinator: Coordinator? { get set }
    // 모든 코디네이터는 자신의 자식 코디네이터를 관리
    var childCoordinators: [Coordinator] { get set }
    //  뷰컨트롤러를 보여줄 때 사용될 내비게이션 컨트롤러를 저장
    var navigationController: UINavigationController { get set }
    // 해당 코디네이터가 제어권을 갖도록 하는 메서드. 완전히 만들고 준비되었을 때만 코디네이터를 활성화
    func start()
}

extension Coordinator {
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension Coordinator {
    func push(viewController: UIViewController, navibarHidden: Bool = true, swipe: Bool = true, animated: Bool = true) {
        navigationController.setNavigationBarHidden(navibarHidden, animated: true)
        
        if swipe {
            self.navigationController.interactivePopGestureRecognizer?.isEnabled = swipe
            self.navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func present(_ viewController: UIViewController, style: UIModalPresentationStyle) {
        navigationController.modalPresentationStyle = style
        navigationController.present(viewController, animated: true)
    }
    
    func pop(_ viewController: UIViewController) {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss(animated: Bool = true,completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func setViewController(viewController: UIViewController, animated: Bool = true) {
        navigationController.setViewControllers([viewController], animated: animated)
    }
}
