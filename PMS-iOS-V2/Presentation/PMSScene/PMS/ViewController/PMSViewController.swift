//
//  PMSViewControllerr.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa

final public class PMSViewController: UIViewController {
    @Inject internal var viewModel: PMSViewModel
    private let disposeBag = DisposeBag()
    
    private let pmsImage = PMSImage()
    private let loginButton = BlueButton(title: .loginButton, label: .loginButton)
    private let registerButton = RedButton(title: .registerButton, label: .registerButton)
    private let noLoginButton = NoLoginButton(title: .noLoginButton)
    
    private let PMSStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = UIFrame.height / 10
    }
    
    private let buttonStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30.0
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        setupSubview()
        setNavigationTitle(title: .PMSTitle, accessibilityLabel: .PMSView, isLarge: true)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
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
