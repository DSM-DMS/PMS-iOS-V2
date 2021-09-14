//
//  ChangePasswordViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

final public class ChangePasswordViewController: UIViewController {
    @Inject internal var viewModel: ChangePasswordViewModel
    private let reachability = try! Reachability()
    let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    private let nowPasswordTitle = UILabel().then {
        $0.textColor = Colors.blue.color
        $0.text = LocalizedString.currentPassword.localized
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .center
    }
    
    private let newPasswordTitle = UILabel().then {
        $0.textColor = Colors.blue.color
        $0.text = LocalizedString.newPassword.localized
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .center
    }
    
    private let reNewPasswordTitle = UILabel().then {
        $0.textColor = Colors.blue.color
        $0.text = LocalizedString.reNewPassword.localized
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .center
    }
    
    private let passwordViewStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = UIFrame.height / 15
    }
    
    private let nowPasswordStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let newPasswordStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let reNewPasswordStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private let checkImage = CheckImage()
    private let nowPasswordEyeButton = EyeButton()
    private let newPasswordEyeButton = EyeButton()
    let changePasswordButton = BlueButton(title: .confirm, label: .toChangePasswordButton)
    
    let nowPasswordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    let newPasswordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    let reNewPasswordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private let nowPasswordTextField = PMSTextField(title: .passwordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    private let newPasswordTextField = PMSTextField(title: .passwordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    private let reNewPasswordTextField = PMSTextField(title: .rePasswordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    private let reNewPasswordValidMsg = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.textColor = Colors.red.color
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = LocalizedString.changePasswordTitle.localized
        self.setupSubview()
        self.bindOutput()
        self.setDelegate()
        self.addKeyboardNotification()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.view_changePassword.log()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(passwordViewStack)
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        passwordViewStack.addArrangeSubviews([nowPasswordStackView, newPasswordStackView, reNewPasswordStackView, changePasswordButton])
        
        nowPasswordStackView.addArrangeSubviews([nowPasswordTitle, nowPasswordTextField, nowPasswordLine])
        nowPasswordStackView.addSubview(nowPasswordEyeButton)
        
        nowPasswordLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
        nowPasswordEyeButton.snp.makeConstraints {
            $0.trailing.equalTo(nowPasswordLine.snp_trailingMargin)
            $0.centerY.equalTo(nowPasswordTextField)
        }
        
        newPasswordStackView.addArrangeSubviews([newPasswordTitle, newPasswordTextField, newPasswordLine])
        newPasswordStackView.addSubview(newPasswordEyeButton)
        
        newPasswordLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
        newPasswordEyeButton.snp.makeConstraints {
            $0.trailing.equalTo(nowPasswordLine.snp_trailingMargin)
            $0.centerY.equalTo(newPasswordTextField)
        }
        
        reNewPasswordStackView.addArrangeSubviews([reNewPasswordTitle, reNewPasswordTextField, reNewPasswordLine])
        reNewPasswordStackView.addSubview(checkImage)
        reNewPasswordStackView.addSubview(reNewPasswordValidMsg)
        reNewPasswordLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 70)
        }
        checkImage.snp.makeConstraints {
            $0.trailing.equalTo(reNewPasswordLine.snp_trailingMargin)
            $0.centerY.equalTo(reNewPasswordTextField)
            $0.bottom.equalTo(reNewPasswordLine.snp_topMargin).offset(-10)
        }
        reNewPasswordValidMsg.snp.makeConstraints {
            $0.top.equalTo(reNewPasswordStackView.snp_bottomMargin).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        passwordViewStack.snp.makeConstraints {
            $0.centerX.equalTo(view.layoutMarginsGuide)
            $0.centerY.equalTo(view.layoutMarginsGuide).offset(-UIFrame.width / 8.5)
        }
    }
    
    private func bindInput() {
        reachability.rx.isDisconnected
            .bind(to: viewModel.input.noInternet)
            .disposed(by: disposeBag)
        
        nowPasswordTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.nowPasswordText)
            .disposed(by: disposeBag)
        
        newPasswordTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.newPasswordText)
            .disposed(by: disposeBag)
        
        reNewPasswordTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.reNewPasswordText)
            .disposed(by: disposeBag)
        
        changePasswordButton.rx.tap
            .bind(to: viewModel.input.changePasswordButtonTapped)
            .disposed(by: disposeBag)
        
        nowPasswordEyeButton.rx.tap
            .bind(to: viewModel.input.nowPasswordEyeButtonTapped)
            .disposed(by: disposeBag)
        
        newPasswordEyeButton.rx.tap
            .bind(to: viewModel.input.newPasswordEyeButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isNowPasswordTyping
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.nowPasswordLine.backgroundColor = Colors.blue.color
                } else {
                    self?.nowPasswordLine.backgroundColor = .gray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isNewPasswordTyping
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.newPasswordLine.backgroundColor = Colors.blue.color
                } else {
                    self?.newPasswordLine.backgroundColor = .gray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isReNewPasswordTyping
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.reNewPasswordLine.backgroundColor = Colors.blue.color
                } else {
                    self?.reNewPasswordLine.backgroundColor = .gray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isNowPasswordEyed
            .map { !$0 }
            .bind(to: nowPasswordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        viewModel.output.isNewPasswordEyed
            .map { !$0 }
            .bind(to: newPasswordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        viewModel.output.changePasswordButtonIsEnable
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.changePasswordButton.isEnabled = bool
                    self?.changePasswordButton.alpha = 1.0
                } else {
                    self?.changePasswordButton.isEnabled = bool
                    self?.changePasswordButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.nowPasswordEyeVisiable
            .map { !$0 }
            .bind(to: nowPasswordEyeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.newPasswordEyeVisiable
            .map { !$0 }
            .bind(to: newPasswordEyeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.isReNewPasswordValid
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.checkImage.tintColor = Colors.green.color
                } else {
                    self?.checkImage.tintColor = Colors.red.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isReNewPasswordValidMsg
            .bind(to: reNewPasswordValidMsg.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func setDelegate() {
        nowPasswordTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] _ in
                self?.nowPasswordTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        newPasswordTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] _ in
                self?.newPasswordTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        reNewPasswordTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] _ in self?.reNewPasswordTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

extension ChangePasswordViewController {
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
                self.view.frame.origin.y -= keyboardHeight / 3
            }
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height
                self.view.frame.origin.y += keyboardHeight / 3
            }
        }
    }
}
