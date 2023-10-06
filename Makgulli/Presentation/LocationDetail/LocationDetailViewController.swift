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
    
    var data: StoreVO?
    
    private var locationDetailView = LocationDetailView()
    
    override func loadView() {
        self.view = locationDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        locationDetailView.titleView.bookMarkButton.rx.tap
            .subscribe(onNext: { _ in
                print("bookMarkButton")
            })
            .disposed(by: disposeBag)
        
        locationDetailView.rateView.currentStarSubject
            .distinctUntilChanged()
            .bind(onNext: { count in
                print(count)
            })
            .disposed(by: disposeBag)
        
        Observable.just(episodeData)
            .withUnretained(self)
            .bind(onNext: { owner, vo in
                owner.locationDetailView.applyCollectionViewDataSource(by: vo)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationDetailView.rateView.currentStar = 3
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
