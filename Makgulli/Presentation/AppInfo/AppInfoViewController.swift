//
//  AppInfoViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources


final class AppInfoViewController: BaseViewController {
    
    enum AppInfoType: CaseIterable, CustomStringConvertible {
        case appInfo
        
        var contents: [String] {
            switch self {
            case .appInfo:
                return ["문의하기", "개인정보 처리방침", "오픈소스 사용정보", "버전정보"]
            }
        }
        
        var numberOfRowInSections: Int {
            return contents.count
        }
        
        var description: String {
            switch self {
            case .appInfo:
                return "앱 정보"
            }
        }
    }
    
    private lazy var appInfoTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private typealias SectionOfAppInfo = SectionModel<AppInfoType, String>
    private var dataSource = RxTableViewSectionedReloadDataSource<SectionOfAppInfo>( configureCell: { (dataSource, tableView, indexPath, item) in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell", for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = item
        return cell
    }, titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model.description
    })
    
    private let sections: [SectionModel<AppInfoType, String>] = AppInfoType.allCases.map { section in
        SectionModel(model: section, items: section.contents)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func bind() {
        Observable.just(sections)
            .bind(to: appInfoTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        view.addSubview(appInfoTableView)
    }
    
    override func setConstraints() {
        appInfoTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
}
