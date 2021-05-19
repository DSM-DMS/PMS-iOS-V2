//
//  DeveloperViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit

class DeveloperViewController: UIViewController {
    let viewModel: DeveloperViewModel
    
    init(viewModel: DeveloperViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
