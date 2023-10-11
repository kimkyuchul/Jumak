//
//  WriteEpisodeViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import UIKit

import RxSwift
import RxCocoa
import PhotosUI

final class WriteEpisodeViewController: BaseViewController {
    
    private let episodeView = WriteEpisodeView()
    private let viewModel: WriteEpisodeViewModel
    private let episodeThumbnailRelay = PublishRelay<UIImage>()
    
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
        print(#function)
    }
    
    override func bind() {
        let input = WriteEpisodeViewModel.Input(
            viewDidLoadEvent: Observable.just(()).asObservable(),
            didSelectWriteButton: episodeView.rx.tapWrite.asObservable().throttle(.milliseconds(300), scheduler: MainScheduler.instance),
            didSelectDatePicker: episodeView.episodeDateView.rx.date.asObservable(), didSelectImage: episodeView.episodeContentView.rx.hasImage)
        let output = viewModel.transform(input: input)
        
        output.placeName
            .bind(to: episodeView.rx.placeTitle)
            .disposed(by: disposeBag)
        
        output.date
            .withUnretained(self)
            .bind(onNext: { owner, date in
                print(date)
            })
            .disposed(by: disposeBag)
        
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
        
        episodeView.episodeContentView.rx.imageViewTapGesture
            .emit(with: self, onNext: { owner, _ in
                owner.showPhotoGallery()
            })
            .disposed(by: disposeBag)
        
        episodeThumbnailRelay
            .bind(to: episodeView.episodeContentView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func showPhotoGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
}

extension WriteEpisodeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    image.preparingThumbnail(of: CGSize(width: 140, height: 140))
                    self?.episodeThumbnailRelay.accept(image)
                }
            }
        }
    }
}
