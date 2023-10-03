//
//  LocationDetailViewController.swift
//  Makgulli
//
//  Created by 김규철 on 2023/10/02.
//

import UIKit


final class LocationDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = .pink
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
