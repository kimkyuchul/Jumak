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
    private let deleteButtonAction = PublishRelay<Void>()
    
    init(viewModel: EpisodeDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    deinit {
        print("deinit")
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
            didSelectBackButton: detailView.rx.backButtonTap.throttle(.milliseconds(300), scheduler: MainScheduler.instance),
            didSelectDeleteButton: deleteButtonAction.asObservable())
        let output = viewModel.transform(input: input)
        
        output.episode
            .bind(to: detailView.rx.episode)
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        detailView.rx.deleteButtonTap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.presentAlert(type: .deleteEpisode, leftButtonAction: nil) {
                    owner.deleteButtonAction.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
}
