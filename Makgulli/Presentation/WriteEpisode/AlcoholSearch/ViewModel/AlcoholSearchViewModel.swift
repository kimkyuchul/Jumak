//
//  AlcoholSearchViewModel.swift
//  Makgulli
//
//  Created by 김규철 on 5/11/26.
//

import Foundation

import RxSwift
import RxRelay

final class AlcoholSearchViewModel: ViewModelType, Coordinatable {
    weak var coordinator: AlcoholSearchCoordinator?
    var disposeBag: DisposeBag = .init()
    
    private static let letters: [Character] = Array("abcdefghijklmnopqrstuvwxyz")
    
    private struct State {
        var currentLetterIndex: Int = 0
        var sections: [AlcoholSearchSection] = []
        
        var hasMore: Bool {
            currentLetterIndex < AlcoholSearchViewModel.letters.count
        }
    }
    
    private var currentLetter: Character {
        Self.letters[state.currentLetterIndex]
    }
        
    private let searchAlcoholUseCase: SearchAlcoholUseCase
    private var state = State()
    private let output = Output()
    
    private let fetchTrigger = PublishRelay<Character>()
    
    init(searchAlcoholUseCase: SearchAlcoholUseCase) {
        self.searchAlcoholUseCase = searchAlcoholUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let willDisplayCell: Observable<IndexPath>
        let didTapCloseButton: Observable<Void>
        let didTapLayoutToggle: Observable<Void>
        let didSelectAlcohol: Observable<AlcoholVO>
    }

    struct Output {
        let snapshot = PublishRelay<[AlcoholSearchSection]>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let showErrorAlert = PublishRelay<Error>()
        let layoutMode = BehaviorRelay<AlcoholSearchLayoutMode>(value: .grid)
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoadEvent
            .bind(with: self) { owner, _ in
                owner.fetchTrigger.accept(owner.currentLetter)
            }
            .disposed(by: disposeBag)
        
        input.willDisplayCell
            .bind(with: self) { owner, indexPath in
                guard owner.canLoadMore(at: indexPath) else { return }
                owner.fetchTrigger.accept(owner.currentLetter)
            }
            .disposed(by: disposeBag)

        input.didTapCloseButton
            .bind(with: self) { owner, _ in
                owner.coordinator?.dismissAlcoholSearch()
            }
            .disposed(by: disposeBag)

        input.didSelectAlcohol
            .bind(with: self) { owner, alcohol in
                owner.coordinator?.selectAlcohol(alcohol)
            }
            .disposed(by: disposeBag)

        input.didTapLayoutToggle
            .bind(with: self) { owner, _ in
                owner.output.layoutMode.accept(owner.output.layoutMode.value.toggled)
            }
            .disposed(by: disposeBag)

        bindFetchPipeline()
        
        return output
    }
    
    private func bindFetchPipeline() {
        fetchTrigger
            .do(onNext: { [weak self] _ in
                self?.output.isLoading.accept(true)
            })
            .flatMapLatest { [weak self] letter -> Observable<(Character, Event<[AlcoholVO]>)> in
                guard let self else { return .empty() }
                return self.searchAlcoholUseCase.searchByFirstLetter(String(letter))
                    .asObservable()
                    .materialize()
                    .map { (letter, $0) }
            }
            .do(onNext: { [weak self] _ in
                self?.output.isLoading.accept(false)
            })
            .bind(with: self) { owner, pair in
                let (letter, event) = pair
                switch event {
                case .next(let alcohols) where alcohols.isEmpty:
                    owner.state.currentLetterIndex += 1
                    if owner.state.hasMore { owner.fetchTrigger.accept(owner.currentLetter) }
                    
                case .next(let alcohols):
                    owner.state.currentLetterIndex += 1
                    owner.appendSection(letter: letter, alcohols: alcohols)
                    owner.output.snapshot.accept(owner.state.sections)
                    
                case .error(let error):
                    owner.output.showErrorAlert.accept(error)
                    
                case .completed:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func canLoadMore(at indexPath: IndexPath) -> Bool {
        guard !output.isLoading.value, state.hasMore,
              let last = state.sections.last,
              let lastItemIndex = last.items.indices.last
        else { return false }
        return indexPath == IndexPath(item: lastItemIndex, section: state.sections.count - 1)
    }
    
    private func appendSection(letter: Character, alcohols: [AlcoholVO]) {
        let items = alcohols.map { AlcoholSearchItem.alcohol($0) }
        state.sections.append(AlcoholSearchSection(letter: letter, items: items))
    }
}
