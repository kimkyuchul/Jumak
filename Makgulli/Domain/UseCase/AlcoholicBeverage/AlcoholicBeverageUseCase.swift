//
//  AlcoholicBeverageUseCase.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

import Combine

protocol AlcoholicBeverageUseCase: AnyObject {
    func fetchAlcoholicBeverageList(page: Int)
    
    var error: PassthroughSubject<Error, Never> { get }
    var alcoholicBeverage: PassthroughSubject<AlcoholicBeverage, Never> { get }
}

final class DefaultAlcoholicBeverageUseCase: AlcoholicBeverageUseCase {
    private let repository: AlcoholicBeverageListRepository
    private var cancellables = Set<AnyCancellable>()
    
    let error = PassthroughSubject<Error, Never>()
    let alcoholicBeverage = PassthroughSubject<AlcoholicBeverage, Never>()
    
    init(repository: AlcoholicBeverageListRepository) {
        self.repository = repository
    }
    
    func fetchAlcoholicBeverageList(page: Int) {
        repository.fetchAlcoholicBeverageList(page: page)
            .catch { [weak self] error in
                self?.error.send(error)
                return Empty<AlcoholicBeverage, Never>()
            }
            .withUnretained(self)
            .sink { owner, list in
                owner.alcoholicBeverage.send(list)
            }
            .store(in: &cancellables)
    }
}
