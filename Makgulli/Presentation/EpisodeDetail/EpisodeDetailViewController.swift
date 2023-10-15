//
//  EpisodeDetailViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/15.
//

import UIKit

import RxCocoa
import RxSwift

final class EpisodeDetailViewController: BaseViewController {
    
    private let detailView = EpisodeDetailView()
    private let viewModel: EpisodeDetailViewModel
    private let episodeDeleteBarButtonItem = UIBarButtonItem(image: ImageLiteral.deleteEpisodeIcon, style: .plain, target: EpisodeDetailViewController.self, action: nil)
    
    init(viewModel: EpisodeDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = EpisodeDetailViewModel.Input(
            viewDidLoadEvent: Observable.just(()).asObservable(),
            didSeletDeleteBarButton: episodeDeleteBarButtonItem.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.episode
            .bind(to: detailView.rx.episode)
            .disposed(by: disposeBag)
        
        output.deleteStoreEpisodeState
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func setNavigationBar() {
        episodeDeleteBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = episodeDeleteBarButtonItem
    }
}
