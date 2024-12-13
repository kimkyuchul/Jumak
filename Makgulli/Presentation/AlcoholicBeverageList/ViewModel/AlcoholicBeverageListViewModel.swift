//
//  AlcoholicBeverageListViewModel.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import Foundation

import Combine

final class AlcoholicBeverageListViewModel: ViewModelType {
    struct Input {
        let viewDidLoadEvent: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let dataSource = CurrentValueSubject<[TraditionalLiquor], Never>([])
    }
    
    struct State {
        var page: Int = 1
        var currentCount: Int = 0
    }
    
    private let useCase: AlcoholicBeverageUseCase
    private var state: State
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: AlcoholicBeverageUseCase) {
        self.useCase = useCase
        self.state = State()
    }
}

extension AlcoholicBeverageListViewModel {
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .withUnretained(self)
            .sink { owner, _ in
                owner.useCase.fetchAlcoholicBeverageList(page: owner.state.page)
            }
            .store(in: &cancellables)
        
        createOutput(output: output)
        return output
    }
    
    private func createOutput(output: Output) {
        useCase.alcoholicBeverage
            .withUnretained(self)
            .sink {  owner, list in
                owner.state.currentCount = list.currentCount
                output.dataSource.send(list.liquor)
            }
            .store(in: &cancellables)
    }
}
