//
//  FilterBottomSheetViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import Foundation

final class FilterBottomSheetViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheet()
        self.view.backgroundColor = .blue
    }
    
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32.0
        }
    }
}
