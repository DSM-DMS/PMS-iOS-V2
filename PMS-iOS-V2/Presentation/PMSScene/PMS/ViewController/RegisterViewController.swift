//
//  RegisterViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit

class RegisterViewController: UIViewController {
    let viewModel: RegisterViewModel
    let loginButton = BlueButton(title: .loginButton, label: .loginButton)
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupSubview()
        setNavigationTitle(title: .registerTitle, accessibilityLabel: .registerView, isLarge: true)
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        
    }
    
    private func bindViewModel() {
        
    }
}
