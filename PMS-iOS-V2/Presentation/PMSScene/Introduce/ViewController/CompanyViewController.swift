//
//  CompanyViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import Reachability
import RxSwift
import RxCocoa

class CompanyViewController: UIViewController {
    let viewModel: CompanyViewModel
    private let reachability = try! Reachability()
    private let disposeBag = DisposeBag()
    
    init(viewModel: CompanyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = LocalizedString.companyTitle.localized
        self.bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func bindInput() {
        
    }
    
    private func bindOutput() {
        
    }
}
