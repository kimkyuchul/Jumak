//
//  LocationDetailViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/02.
//

import UIKit

import RxCocoa
import RxSwift


final class LocationDetailViewController: BaseViewController {
    
    let episodeData: [EpisodeVO] = [EpisodeVO(date: "2020", title: "모든 플레이어의 정답지가", content: "ㅁ", imageURL: "k.circle.fill", alcohol: "a", mixedAlcohol: "a", drink: 1.5), EpisodeVO(date: "2020", title: "모든 플레이어의 정답지가", content: "ㅁ", imageURL: "k.circle.fill", alcohol: "a", mixedAlcohol: "a", drink: 1.5), EpisodeVO(date: "2020", title: "모든 플레이어의 정답지가", content: "ㅁ", imageURL: "k.circle.fill", alcohol: "a", mixedAlcohol: "a", drink: 1.5), EpisodeVO(date: "2020", title: "모든 플레이어의 정답지가", content: "ㅁ", imageURL: "k.circle.fill", alcohol: "a", mixedAlcohol: "a", drink: 1.5)]

    private var locationDetailView = LocationDetailView()
    
    private let viewModel: LocationDetailViewModel
    
    init(viewModel: LocationDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        self.view = locationDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func bind() {
        let input = LocationDetailViewModel
            .Input(viewDidLoadEvent: Observable.just(()).asObservable(),
                   viewDidDisappear: self.rx.viewDidDisappear.map { _ in },
                   didSelectRate: locationDetailView.rateView.currentStarSubject)
        let output = viewModel.transform(input: input)
                     
        output.hashTag
            .bind(to: locationDetailView.titleView.rx.hashTag)
            .disposed(by: disposeBag)
        
        output.placeName
            .bind(to: locationDetailView.titleView.rx.placeName)
            .disposed(by: disposeBag)
        
        output.distance
            .bind(to: locationDetailView.titleView.rx.distance)
            .disposed(by: disposeBag)
        
        output.type
            .bind(to: locationDetailView.infoView.rx.type)
            .disposed(by: disposeBag)
        
        output.address
            .bind(to: locationDetailView.infoView.rx.address)
            .disposed(by: disposeBag)

        output.roadAddress
            .bind(to: locationDetailView.infoView.rx.roadAddress)
            .disposed(by: disposeBag)
        
        output.phone
            .bind(to: locationDetailView.infoView.rx.phone)
            .disposed(by: disposeBag)
        
        output.rate
            .withUnretained(self)
            .bind(onNext: { owner, rate in
                owner.locationDetailView.rateView.currentStar = rate
            })
            .disposed(by: disposeBag)
    }
}
