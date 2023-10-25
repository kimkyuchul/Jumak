//
//  RxViewController+.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import UIKit

import RxSwift
import RxCocoa


extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
      return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    var viewDidAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }

    var viewWillDisappear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    var viewDidDisappear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIButton {
    var isSelected: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: [.touchUpInside],
            getter: { $0.isSelected },
            setter: { $0.isSelected = $1 })
    }
}

extension Reactive where Base: UIViewController {
    func makeErrorAlert(
        title: String?,
        message: String?,
        cancelButtonTitle: String?,
        completion: (() -> Void)? = nil
    ) -> Observable<Void> {
        return Observable.create { [weak base] observer in
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
                observer.onNext(())
                observer.onCompleted()
            }
            alertController.addAction(cancelAction)
            
            base?.present(alertController, animated: true, completion: completion)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
}
