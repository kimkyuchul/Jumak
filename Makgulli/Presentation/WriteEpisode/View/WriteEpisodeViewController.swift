//
//  WriteEpisodeViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/10.
//

import UIKit
import PhotosUI

import RxSwift
import RxCocoa

final class WriteEpisodeViewController: BaseViewController {
    
    private let episodeView = WriteEpisodeView()
    private let viewModel: WriteEpisodeViewModel
    private let episodeThumbnailRelay = PublishRelay<UIImage>()
    private let episodeThumbnailDataSubject = PublishSubject<Data>()
    
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
    }
    
    override func bind() {
        let input = WriteEpisodeViewModel.Input(
            viewDidLoadEvent: Observable.just(()).asObservable(), 
            didSelectBackButton: episodeView.rx.tapDismiss.asObservable(),
            didSelectDatePicker: episodeView.episodeDateView.rx.date.asObservable(),
            commentTextFieldDidEditEvent: episodeView.episodeContentView.rx.comment,
            didSelectImage: episodeView.episodeContentView.rx.hasImage,
            episodeImageData: episodeThumbnailDataSubject.asObserver(),
            drinkNameTextFieldDidEditEvent: episodeView.episodeDrinkNameView.rx.drinkName,
            didSelectDefaultDrinkCheckButton: episodeView.episodeDrinkNameView.rx.tapCheckButton,
            didSelectMinusDrinkCountButton: episodeView.episodeDrinkCountView.rx.tapMinus.asObservable(),
            didSelectPlusDrinkCountButton: episodeView.episodeDrinkCountView.rx.tapPlus.asObservable(),
            didSelectQuantity: episodeView.episodeDrinkCountView.quantitySubject,
            didSelectWriteButton: episodeView.rx.tapWrite.asObservable().throttle(.milliseconds(300), scheduler: MainScheduler.instance))
        let output = viewModel.transform(input: input)
        
        output.placeName
            .bind(to: episodeView.rx.placeTitle)
            .disposed(by: disposeBag)
                
        output.isForgetDrinkName
            .bind(to: episodeView.episodeDrinkNameView.rx.isForgetDrinkName)
            .disposed(by: disposeBag)
        
        output.drinkCount
            .bind(to: episodeView.episodeDrinkCountView.rx.drinkCount)
            .disposed(by: disposeBag)
        
        output.writeButtonIsEnabled
            .bind(to: episodeView.rx.writeEnabled)
            .disposed(by: disposeBag)
        
        output.updateStoreEpisode
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showErrorAlert
            .withUnretained(self)
            .flatMap { owner, error in
                dump(error)
                return owner.rx.makeErrorAlert(title: "내부 에러", message: "알수없는 에러가 발생했습니다.", cancelButtonTitle: "확인")
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
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
                let resizeImage = image.resize(newWidth: 200)
                let imageData = resizeImage.jpegData(compressionQuality: 0.5)
                
                DispatchQueue.main.async {
                    self?.episodeThumbnailRelay.accept(resizeImage)
                    self?.episodeThumbnailDataSubject.onNext(imageData ?? Data())
                }
            }
        }
    }
}
