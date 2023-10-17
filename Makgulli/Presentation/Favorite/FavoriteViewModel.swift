//
//  FavoriteViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/17.
//

import Foundation

import RxRelay
import RxSwift

final class FavoriteViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        
    }

    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
