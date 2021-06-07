//
//  LoginViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import Reachability

class LoginViewController: UIViewController {
    let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    private let reachability = try! Reachability()
    let activityIndicator = UIActivityIndicatorView()
    
    let loginViewStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 40.0
    }
    
    let emailView = UIStackView().then {
        $0.spacing = 15.0
        $0.alignment = .leading
    }
    
    let emailStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    let passwordView = UIStackView().then {
        $0.spacing = 15.0
        $0.alignment = .leading
    }
    
    let passwordStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    let oAuthStackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    let facebookButton = FacebookButton(label: .facebookLogin)
    let naverButton = NaverButton(label: .naverRegister)
    let kakaotalkButton = KakaotalkButton(label: .kakaotalkLogin)
    let appleButton = AppleButton(label: .appleLogin)
    let loginButton = BlueButton(title: .loginButton, label: .loginButton)
    
    let personImage = PersonImage()
    let lockImage = LockImage()
    let emailLine = UIView().then {
        $0.backgroundColor = .gray
    }
    let passwordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    let emailTextField = PMSTextField(title: .emailPlaceholder)
    let passwordTextField = PMSTextField(title: .passwordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    let passwordEyeButton = EyeButton()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        self.setupSubview()
        self.addKeyboardNotification()
        self.setNavigationTitle(title: .loginTitle, accessibilityLabel: .loginView, isLarge: true)
        self.bindInput()
        self.bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
        AnalyticsManager.view_signIn.log()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupSubview() {
        let leftSpacing = EmptyView()
        let rightSpacing = EmptyView()
        let emailSpacing = UIView().then { $0.frame.size = CGSize(width: 20, height: 20)}
        let passwordSpacing = UIView().then { $0.frame.size = CGSize(width: 20, height: 20)}
        
        view.backgroundColor = Colors.white.color
        view.addSubview(loginViewStack)
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loginViewStack.addArrangeSubviews([emailStackView, passwordStackView, oAuthStackView, loginButton])
        emailView.addArrangeSubviews([emailSpacing, personImage, emailTextField])
        emailStackView.addArrangeSubviews([emailView, emailLine])
        emailLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
        passwordView.addArrangeSubviews([passwordSpacing, lockImage, passwordTextField])
        passwordStackView.addArrangeSubviews([passwordView, passwordLine])
        passwordStackView.addSubview(passwordEyeButton)
        passwordLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
        passwordEyeButton.snp.makeConstraints {
            $0.trailing.equalTo(passwordLine.snp_trailingMargin)
            $0.centerY.equalToSuperview()
        }
        oAuthStackView.addArrangeSubviews([leftSpacing, facebookButton, naverButton, kakaotalkButton, appleButton, rightSpacing])
        
        loginViewStack.snp.makeConstraints {
            $0.center.equalTo(view.layoutMarginsGuide)
        }
    }
    
    private func bindInput() {
        emailTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        reachability.rx.isDisconnected
            .bind(to: viewModel.input.noInternet)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.input.loginButtonTapped)
            .disposed(by: disposeBag)
        
        passwordEyeButton.rx.tap
            .bind(to: viewModel.input.eyeButtonTapped)
            .disposed(by: disposeBag)
        
        facebookButton.rx.tap
            .bind(to: viewModel.input.facebookButtonTapped)
            .disposed(by: disposeBag)
        
        naverButton.rx.tap
            .bind(to: viewModel.input.naverButtonTapped)
            .disposed(by: disposeBag)
        
        kakaotalkButton.rx.tap
            .bind(to: viewModel.input.kakaotalkButtonTapped)
            .disposed(by: disposeBag)
        
        appleButton.rx.tap
            .bind(to: viewModel.input.appleButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isEmailTyping
            .subscribe(onNext: {
                if $0 {
                    self.emailLine.backgroundColor = Colors.blue.color
                    self.personImage.tintColor = Colors.blue.color
                } else {
                    self.emailLine.backgroundColor = .gray
                    self.personImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isPasswordTyping
            .subscribe(onNext: {
                if $0 {
                    self.passwordLine.backgroundColor = Colors.blue.color
                    self.lockImage.tintColor = Colors.blue.color
                } else {
                    self.passwordLine.backgroundColor = .gray
                    self.lockImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isPasswordEyed
            .map { !$0 }
            .bind(to: passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        viewModel.output.loginButtonIsEnable
            .subscribe(onNext: {
                if $0 {
                    self.loginButton.isEnabled = $0
                    self.loginButton.alpha = 1.0
                } else {
                    self.loginButton.isEnabled = $0
                    self.loginButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.passwordEyeVisiable
            .map { !$0 }
            .bind(to: passwordEyeButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupDelegate() {
        emailTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.emailTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.passwordTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if self.view.frame.origin.y == 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height
                self.view.frame.origin.y -= keyboardHeight / 2
            }
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height
                self.view.frame.origin.y += keyboardHeight / 2
            }
        }
    }
}
