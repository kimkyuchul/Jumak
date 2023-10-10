//
//  WriteEpisodeViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import UIKit

import RxSwift
import RxCocoa


final class WriteEpisodeViewController: BaseViewController {
    
    private let episodeView = WriteEpisodeView()
    private let viewModel: WriteEpisodeViewModel
    
    init(viewModel: WriteEpisodeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = episodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "에피소드 기록하기"
        self.view.backgroundColor = .pink
    }
    
    override func bind() {
        let input = WriteEpisodeViewModel.Input(
            didSelectWriteButton: episodeView.rx.tapWrite.asObservable().throttle(.milliseconds(300), scheduler: MainScheduler.instance))
        let output = viewModel.transform(input: input)
        
        output.updateStoreEpisode
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        episodeView.rx.tapDismiss
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
