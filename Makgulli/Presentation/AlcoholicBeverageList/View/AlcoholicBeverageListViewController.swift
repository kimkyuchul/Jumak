//
//  AlcoholicBeverageListViewController.swift
//  Makgulli
//
//  Created by kyuchul on 12/13/24.
//

import UIKit
import Combine

final class AlcoholicBeverageListViewController: BaseViewController {
    private let viewModel: AlcoholicBeverageListViewModel
    private let viewDidLoadEvent = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AlcoholicBeverageListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .pink
        
        viewDidLoadEvent.send(())
    }
    
    override func bind() {
        let input = AlcoholicBeverageListViewModel.Input(viewDidLoadEvent: viewDidLoadEvent)
        
        let output = viewModel.transform(input: input)
        
        output.dataSource
            .receive(on: DispatchQueue.main)
            .sink { item in
                print(item)
                
            }
            .store(in: &cancellables)
    }
}
