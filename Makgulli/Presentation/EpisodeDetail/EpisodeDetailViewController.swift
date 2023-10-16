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
    private let episodeDeleteBarButtonItem = UIBarButtonItem(image: ImageLiteral.deleteEpisodeIcon, style: .plain, target: EpisodeDetailViewController.self, action: nil)
    private let viewModel: EpisodeDetailViewModel
    private let deleteButtonAction = PublishRelay<Void>()
    
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
            didSeletDeleteButton: deleteButtonAction.asObservable())
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
    
    override func bindAction() {
        episodeDeleteBarButtonItem.rx.tap.throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.presentAlert(type: .deleteEpisode, leftButtonAction: nil) { [weak self] in
                    self?.deleteButtonAction.accept(Void())
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func setNavigationBar() {
        episodeDeleteBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = episodeDeleteBarButtonItem
    }
}
