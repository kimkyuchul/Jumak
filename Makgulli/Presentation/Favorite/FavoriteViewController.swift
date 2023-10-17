//
//  FavoriteViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/09/30.
//

import UIKit

import RxSwift
import RxCocoa

final class FavoriteViewController: BaseViewController {
    
    private let viewModel: FavoriteViewModel
    
    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .pink
    }
    
    override func bind() {
        let input = FavoriteViewModel.Input(viewDidLoadEvent: Observable.just(Void()))
        let output = viewModel.transform(input: input)
    }
}
