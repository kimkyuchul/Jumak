//
//  ViewModelType.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/27.
//

import Foundation

import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }

    func transform(input: Input) -> Output
}
