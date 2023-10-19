//
//  FilterBottomSheetViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/18.
//

import UIKit

import RxCocoa
import RxSwift

final class FilterBottomSheetViewController: BaseViewController {
    
    private var filterType: FilterType = .recentlyAddedBookmark
    
    private let filterBottomSheetHeaderView = FilterBottomSheetHeaderView()
    private lazy var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSheet()
    }
    
    override func bind() {
        Observable.just(FilterType.allCases)
            .bind(to: filterTableView.rx.items(cellIdentifier: "FilterTableViewCell", cellType: FilterTableViewCell.self)) {
                index, item, cell in
                cell.configureCell(type: item)
            }
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        filterTableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                owner.filterType = FilterType.allCases[indexPath.row]
            })
            .disposed(by: disposeBag)
        
        filterBottomSheetHeaderView.rx.tapFilterChange
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                UserDefaultHandler.reverseFilter = false
                NotificationCenterManager.filterStore.post(object: owner.filterType)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
    }
    
    override func setHierarchy() {
        [filterBottomSheetHeaderView, filterTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        filterBottomSheetHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(54)
        }
        
        filterTableView.snp.makeConstraints { make in
            make.top.equalTo(filterBottomSheetHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setNavigationBar() {
        self.title = "정렬 기준"
    }
    
    override func setLayout() {
        view.backgroundColor = .white
    }
}
