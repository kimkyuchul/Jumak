//
//  AppInfoViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/24.
//

import UIKit
import SafariServices

import RxSwift
import RxCocoa
import RxDataSources

final class AppInfoViewController: BaseViewController {
    private let viewModel: AppInfoViewModel
    private let sections: [SectionModel<AppInfoType, AppInfoSection>] = AppInfoType.allCases.map { section in
        SectionModel(model: section, items: section.contents)
    }
    private typealias SectionOfAppInfo = SectionModel<AppInfoType, AppInfoSection>
    
    init(viewModel: AppInfoViewModel) {
        self.viewModel = viewModel
        super.init()
    }
        
    private let navigationBar = JumakNavigationBar()
    private lazy var appInfoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.register(AppInfoTableViewCell.self, forCellReuseIdentifier: "AppInfoTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionOfAppInfo>( configureCell: { (dataSource, tableView, indexPath, item) in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfoTableViewCell", for: indexPath) as? AppInfoTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(item: item.description)
        
        let section = AppInfoType.appInfo
        
        if case .versionInfo = section.contents[indexPath.row] {
            cell.configureAppVersion(version: Bundle.main.appVersion)
        }
        
        return cell
    }, titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model.description
    })
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func bind() {
        let input = AppInfoViewModel.Input(
            didSelectBackButton: navigationBar.backButtonAction(),
            didSelectTablbViewItem: appInfoTableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.showToast
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.showToast(message: "항상 최신 버전의 주막을 이용해보세요.")
            }
            .disposed(by: disposeBag)
        
        Observable.just(sections)
            .bind(to: appInfoTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        appInfoTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
        
    override func setHierarchy() {
        [navigationBar, appInfoTableView]
            .forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        appInfoTableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalTo(navigationBar.snp.horizontalEdges)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func setLayout() {
        view.backgroundColor = .white
    }
}

extension AppInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldLineSeed(size: ._24)
        header.textLabel?.textColor = .black
        
        if let label = header.textLabel {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 18).isActive = true
            label.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        }
        
        header.textLabel?.sizeToFit()
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 100
        }
    }
}
