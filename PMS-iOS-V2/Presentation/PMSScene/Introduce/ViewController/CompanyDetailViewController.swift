//
//  CompanyDetailViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit

class CompanyDetailViewController: UIViewController {
    let viewModel: CompanyViewModel
    let name: String
    
    init(viewModel: CompanyViewModel, name: String) {
        self.viewModel = viewModel
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
