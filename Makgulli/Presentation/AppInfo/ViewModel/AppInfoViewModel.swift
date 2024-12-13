//
//  AppInfoViewModel.swift
//  Makgulli
//
//  Created by kyuchul on 11/25/24.
//

import Foundation

import RxRelay
import RxSwift

final class AppInfoViewModel: ViewModelType, Coordinatable {
    weak var coordinator: AppInfoCoordinator?
    var disposeBag: DisposeBag = .init()
    
    deinit {
        coordinator?.didFinish()
    }
    
    struct Input {
        let didSelectBackButton: Observable<Void>
        let didSelectTablbViewItem: Observable<IndexPath>
    }
    
    struct Output {
        let showToast = PublishRelay<Void>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didSelectBackButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.popAppInfo()
            }
            .disposed(by: disposeBag)
        
        input.didSelectTablbViewItem
            .map { ($0, AppInfoType.appInfo) }
            .bind(with: self) { owner, items in
                let indexPath = items.0
                let section = items.1
                
                switch section.contents[indexPath.row] {
                case .inquiry:
                    owner.coordinator?.startInquiry()
                    
                case .privacyPolicy:
                    guard let url = URL(string: URLLiteral.policy.trimmingWhitespace()) else { return }
                    owner.coordinator?.startSafariWebView(url)
                    
                case .openSourceInfo:
                    guard let url = URL(string: URLLiteral.openSourceInfo.trimmingWhitespace()) else { return }
                    owner.coordinator?.startSafariWebView(url)
                    
                case .versionInfo:
                    output.showToast.accept(())
                }
            }
            .disposed(by: disposeBag)

        return output
    }
}

