//
//  MakgulliTests.swift
//  MakgulliTests
//
//  Created by kyuchul on 12/14/24.
//

import Foundation
import Combine
import Testing
@testable import Makgulli

struct MakgulliTests {
    private var sut: AlcoholicBeverageListViewModel!
    private var input: AlcoholicBeverageListViewModel.Input = .init(
        viewDidLoadEvent: PassthroughSubject<Void, Never>(),
        scrollToBottom: PassthroughSubject<Void, Never>()
    )
    private var output: AlcoholicBeverageListViewModel.Output!
    private var subscriptions = Set<AnyCancellable>()
    
    private let mockData: [AlcoholicBeverage] = [
        .init(page: 1, currentCount: 5, totalCount: 10, liquor: []),
        .init(page: 2, currentCount: 10, totalCount: 10, liquor: [])
    ]
    
    @MainActor
    @Test mutating func 전통주리스트화면_첫진입_빈데이터_확인() async throws {
        let useCase = StubAlcoholicBeverageUseCase { page in
                .success(.init(page: page, currentCount: 0, totalCount: 0, liquor: []))
        }
        
        // 테스트
        var expected: [AlcoholicBeverage] = []
        let result = await useCase.fetchAlcoholicBeverageListAsync(page: 1)
        
        switch result {
        case .success(let response):
            expected.append(response)
            
        case .failure(_):
            break
        }
        
        sut = AlcoholicBeverageListViewModel(useCase: useCase)
        output = sut.transform(input: input)
        
        #expect(sut.state.page == 1)
        #expect(output.dataSource.value.isEmpty)
    }
    
    @MainActor
    @Test mutating func 첫번째_페이지_전통주리스트를_가져온다() async throws {
        let data = mockData
        let useCase = StubAlcoholicBeverageUseCase { page in
                .success(data[page - 1])
        }
                    
        // 테스트
        var expected: [AlcoholicBeverage] = []
        let result = await useCase.fetchAlcoholicBeverageListAsync(page: 1)
        
        switch result {
        case .success(let response):
            expected.append(response)
            
        case .failure(_):
            break
        }
        
        sut = AlcoholicBeverageListViewModel(useCase: useCase)
        output = sut.transform(input: input)
        
        input.viewDidLoadEvent.send(())
        try await _Concurrency.Task.sleep(nanoseconds: 500_000_000)
        
        #expect(sut.state.page == 1)
        #expect(output.dataSource.value == expected)
    }
    
    @MainActor
    @Test mutating func 첫번째_두번째_페이지_전통주리스트를_가져온다() async throws {
        let data = mockData
        let useCase = StubAlcoholicBeverageUseCase { page in
                .success(data[page - 1])
        }
        
        //테스트
        var expected: [AlcoholicBeverage] = []
        for page in 1...2 {
            let result = await useCase.fetchAlcoholicBeverageListAsync(page: page)
            
            switch result {
            case .success(let response):
                expected.append(response)
                
            case .failure(_):
                break
            }
        }
        
        sut = AlcoholicBeverageListViewModel(useCase: useCase)
        output = sut.transform(input: input)
        
        
        input.viewDidLoadEvent.send(())
        try await _Concurrency.Task.sleep(nanoseconds: 500_000_000)
        
        input.scrollToBottom.send(())
        try await _Concurrency.Task.sleep(nanoseconds: 500_000_000)
        
        #expect(sut.state.page == 2)
        #expect(output.dataSource.value == expected)
    }
}
