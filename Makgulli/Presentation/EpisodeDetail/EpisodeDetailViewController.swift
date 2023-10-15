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
    
    private let viewModel: EpisodeDetailViewModel
    private let episodeDeleteBarButtonItem = UIBarButtonItem(image: ImageLiteral.bookMarkIcon, style: .plain, target: EpisodeDetailViewController.self, action: nil)
    
    init(viewModel: EpisodeDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .pink
    }
    
    override func bind() {
        let input = EpisodeDetailViewModel.Input(
            viewDidLoadEvent: Observable.just(()).asObservable(),
            didSeletDeleteBarButton: episodeDeleteBarButtonItem.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.episode
            .withUnretained(self)
            .bind(onNext: { owner, episode in
                print(episode)
            })
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
