//
//  PMSViewControllerr.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa

class PMSViewController: UIViewController {
    let viewModel: PMSViewModel
    private let disposeBag = DisposeBag()
    
    let pmsImage = PMSImage()
    let loginButton = BlueButton(title: .loginButton, label: .loginButton)
    let registerButton = RedButton(title: .registerButton, label: .registerButton)
    let noLoginButton = NoLoginButton(title: .noLoginButton)
    
    let PMSStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = UIFrame.height / 10
    }
    
    let buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30.0
    }
    
    init(viewModel: PMSViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupSubview()
        setNavigationTitle(title: .PMSTitle, accessibilityLabel: .PMSView, isLarge: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.view_PMS.log()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(PMSStack)
        view.addSubview(noLoginButton)
        
        buttonStack.addArrangeSubviews([loginButton, registerButton])
        PMSStack.addArrangeSubviews([pmsImage, buttonStack])
        
        PMSStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-15)
        }
        
        noLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp_bottomMargin).offset(-30)
        }
    }
    
    private func bindViewModel() {
        loginButton.rx.tap
            .map { fatalError() }
            .bind(to: viewModel.input.loginButtonTapped)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.input.registerButtonTapped)
            .disposed(by: disposeBag)
        
        noLoginButton.rx.tap
            .bind(to: viewModel.input.noLoginButtonTapped)
            .disposed(by: disposeBag)
    }
}
