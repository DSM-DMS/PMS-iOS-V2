//
//  RegisterViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import Reachability

final public class RegisterViewController: UIViewController {
    internal let viewModel: RegisterViewModel
    private let activityIndicator = UIActivityIndicatorView()
    private let reachability = try! Reachability()
    private let disposeBag = DisposeBag()
    
    private let registerViewStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 40.0
    }
    
    private let nicknameView = UIStackView().then {
        $0.spacing = 15.0
        $0.alignment = .leading
    }
    
    private let nicknameStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let emailView = UIStackView().then {
        $0.spacing = 15.0
        $0.alignment = .leading
    }
    
    private let emailStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let passwordView = UIStackView().then {
        $0.spacing = 15.0
        $0.alignment = .leading
    }
    
    private let passwordStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let rePasswordView = UIStackView().then {
        $0.spacing = 15.0
        $0.alignment = .leading
    }
    
    private let rePasswordStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let oAuthStackView = UIStackView().then {
        $0.alignment = .top
        $0.distribution = .equalSpacing
    }
    
    private let facebookButton = FacebookButton(label: .facebookLogin)
    private let naverButton = NaverButton(label: .naverRegister)
    private let kakaotalkButton = KakaotalkButton(label: .kakaotalkLogin)
    private let appleButton = AppleButton(label: .appleLogin)
    private let registerButton = RedButton(title: .registerButton, label: .registerButton)
    
    private let pencilImage = BlackPencilImage()
    private let personImage = PersonImage()
    private let lockImage = LockImage()
    private let circleCheckImage = CircleCheckImage()
    private let checkImage = CheckImage()
    
    private let nicknameLine = UIView().then {
        $0.backgroundColor = .gray
    }
    private let emailLine = UIView().then {
        $0.backgroundColor = .gray
    }
    private let passwordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    private let rePasswordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private let nicknameTextField = PMSTextField(title: .nicknamePlaceholder)
    private let emailTextField = PMSTextField(title: .emailPlaceholder)
    private let passwordTextField = PMSTextField(title: .passwordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    private let rePasswordTextField = PMSTextField(title: .rePasswordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    private let rePasswordValidMsg = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.textColor = Colors.red.color
    }
    
    private let passwordEyeButton = EyeButton()
    
    internal init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        setupSubview()
        setNavigationTitle(title: .registerTitle, accessibilityLabel: .registerView, isLarge: true)
        bindInput()
        bindOutput()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
        AnalyticsManager.view_signUp.log()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupSubview() {
        let leftSpacing = EmptyView()
        let rightSpacing = EmptyView()
        
        let nicknameSpacing = UIView().then { $0.frame.size = CGSize(width: 20, height: 20)}
        let emailSpacing = UIView().then { $0.frame.size = CGSize(width: 20, height: 20)}
        let passwordSpacing = UIView().then { $0.frame.size = CGSize(width: 20, height: 20)}
        let rePasswordSpacing = UIView().then { $0.frame.size = CGSize(width: 20, height: 20)}
        
        view.backgroundColor = Colors.white.color
        view.addSubview(registerViewStack)
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        registerViewStack.addArrangeSubviews([nicknameStackView, emailStackView, passwordStackView, rePasswordStackView, oAuthStackView, registerButton])
        nicknameView.addArrangeSubviews([nicknameSpacing, pencilImage, nicknameTextField])
        nicknameStackView.addArrangeSubviews([nicknameView, nicknameLine])
        nicknameLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
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
        
        rePasswordView.addArrangeSubviews([rePasswordSpacing, circleCheckImage, rePasswordTextField])
        rePasswordStackView.addArrangeSubviews([rePasswordView, rePasswordLine])
        rePasswordStackView.addSubview(checkImage)
        rePasswordStackView.addSubview(rePasswordValidMsg)
        rePasswordLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
        checkImage.snp.makeConstraints {
            $0.trailing.equalTo(rePasswordLine.snp_trailingMargin)
            $0.centerY.equalToSuperview()
            $0.bottom.equalTo(rePasswordLine.snp_topMargin).offset(-10)
        }
        rePasswordValidMsg.snp.makeConstraints {
            $0.top.equalTo(rePasswordStackView.snp_bottomMargin)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        oAuthStackView.addArrangeSubviews([leftSpacing, facebookButton, naverButton, kakaotalkButton, appleButton, rightSpacing])
        
        registerViewStack.snp.makeConstraints {
            $0.centerX.equalTo(view.layoutMarginsGuide)
            $0.centerY.equalTo(view.layoutMarginsGuide).offset(-UIFrame.width / 8.5)
        }
    }
    
    private func bindInput() {
        reachability.rx.isDisconnected
            .bind(to: viewModel.input.noInternet)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
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
        
        rePasswordTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.rePasswordText)
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .bind(to: viewModel.input.registerButtonTapped)
            .disposed(by: disposeBag)
        
        passwordEyeButton.rx.tap
            .bind(to: viewModel.input.eyeButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isNicknameTyping
            .subscribe(onNext: {
                if $0 {
                    self.nicknameLine.backgroundColor = Colors.red.color
                    self.pencilImage.tintColor = Colors.red.color
                } else {
                    self.nicknameLine.backgroundColor = .gray
                    self.pencilImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isEmailTyping
            .subscribe(onNext: {
                if $0 {
                    self.emailLine.backgroundColor = Colors.red.color
                    self.personImage.tintColor = Colors.red.color
                } else {
                    self.emailLine.backgroundColor = .gray
                    self.personImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isPasswordTyping
            .subscribe(onNext: {
                if $0 {
                    self.passwordLine.backgroundColor = Colors.red.color
                    self.lockImage.tintColor = Colors.red.color
                } else {
                    self.passwordLine.backgroundColor = .gray
                    self.lockImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isRePasswordTyping
            .subscribe(onNext: {
                if $0 {
                    self.rePasswordLine.backgroundColor = Colors.red.color
                    self.circleCheckImage.tintColor = Colors.red.color
                } else {
                    self.rePasswordLine.backgroundColor = .gray
                    self.circleCheckImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isPasswordEyed
            .map { !$0 }
            .bind(to: passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        viewModel.output.registerButtonIsEnable
            .subscribe(onNext: {
                if $0 {
                    self.registerButton.isEnabled = $0
                    self.registerButton.alpha = 1.0
                } else {
                    self.registerButton.isEnabled = $0
                    self.registerButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.passwordEyeVisiable
            .map { !$0 }
            .bind(to: passwordEyeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.isRePasswordValid
            .subscribe(onNext: {
                if $0 {
                    self.checkImage.tintColor = Colors.green.color
                } else {
                    self.checkImage.tintColor = Colors.red.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isRePasswordValidMsg
            .bind(to: rePasswordValidMsg.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func setupDelegate() {
        nicknameTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.nicknameTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
        emailTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.emailTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
        passwordTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.passwordTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
        rePasswordTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.rePasswordTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
    }
}

extension RegisterViewController {
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
