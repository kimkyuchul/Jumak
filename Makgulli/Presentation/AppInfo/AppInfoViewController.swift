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
import SafariServices

final class AppInfoViewController: BaseViewController {
    
    enum AppInfoType: CaseIterable, CustomStringConvertible {
        case appInfo
        
        var contents: [AppInfoSection] {
            switch self {
            case .appInfo:
                return [.inquiry, .privacyPolicy, .openSourceInfo, .versionInfo]
            }
        }
        
        var description: String {
            switch self {
            case .appInfo:
                return "앱 정보"
            }
        }
    }
    
    enum AppInfoSection: String, CustomStringConvertible {
        case inquiry = "문의하기"
        case privacyPolicy = "개인정보 처리방침"
        case openSourceInfo = "오픈소스 사용정보"
        case versionInfo = "버전정보"
        
        var description: String {
            return self.rawValue
        }
    }
    
    private lazy var appInfoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 55
        tableView.showsVerticalScrollIndicator = false
        tableView.register(AppInfoTableViewCell.self, forCellReuseIdentifier: "AppInfoTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private typealias SectionOfAppInfo = SectionModel<AppInfoType, AppInfoSection>
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
    }
    )
    
    private let sections: [SectionModel<AppInfoType, AppInfoSection>] = AppInfoType.allCases.map { section in
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
        
        appInfoTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func bindAction() {
        appInfoTableView.rx.itemSelected
            .withUnretained(self)
            .bind(onNext: { owner, indexPath in
                let section = AppInfoType.appInfo
                
                switch section.contents[indexPath.row] {
                case .inquiry:
                    owner.navigationController?.pushViewController(InquiryViewController(), animated: true)
                case .privacyPolicy:
                    guard
                        let url = URL(string: URLLiteral.policy.trimmingWhitespace()), UIApplication.shared.canOpenURL(url)
                    else { return }
                    let safariViewController = SFSafariViewController(url: url)
                    owner.present(safariViewController, animated: true)
                case .openSourceInfo:
                    guard
                        let url = URL(string: URLLiteral.openSourceInfo.trimmingWhitespace()), UIApplication.shared.canOpenURL(url)
                    else { return }
                    let safariViewController = SFSafariViewController(url: url)
                    owner.present(safariViewController, animated: true)
                case .versionInfo:
                    owner.showToast(message: "최신 버전의 주막입니다.")
                }
            })
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
