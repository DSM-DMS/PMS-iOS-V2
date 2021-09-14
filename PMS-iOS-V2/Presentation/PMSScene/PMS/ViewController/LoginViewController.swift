//
//  LoginViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import Reachability
import NaverThirdPartyLogin
import FBSDKLoginKit
import KakaoOpenSDK
import AuthenticationServices

final public class LoginViewController: UIViewController {
    @Inject internal var viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    private let reachability = try! Reachability()
    public let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - OAuth
    
    private let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let facebookManager = LoginManager()
    
    private let loginViewStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 40.0
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
    
    private let oAuthStackView = UIStackView().then {
        $0.alignment = .top
        $0.distribution = .equalSpacing
    }
    
    private let facebookButton = FacebookButton(label: .facebookLogin)
    private let naverButton = NaverButton(label: .naverRegister)
    private let kakaotalkButton = KakaotalkButton(label: .kakaotalkLogin)
    private let appleButton = AppleButton(label: .appleLogin).then {
        $0.isEnabled = false
    }
    let loginButton = BlueButton(title: .loginButton, label: .loginButton)
    
    private let personImage = PersonImage()
    private let lockImage = LockImage()
    let emailLine = UIView().then {
        $0.backgroundColor = .gray
    }
    let passwordLine = UIView().then {
        $0.backgroundColor = .gray
    }
    private let emailTextField = PMSTextField(title: .emailPlaceholder)
    private let passwordTextField = PMSTextField(title: .passwordPlaceholder).then {
        $0.isSecureTextEntry = true
    }
    let passwordEyeButton = EyeButton()
    
    public init() {
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
    
    public override func viewDidLoad() {
        self.setupSubview()
        self.addKeyboardNotification()
        self.setNavigationTitle(title: .loginTitle, accessibilityLabel: .loginView, isLarge: true)
        self.bindInput()
        self.bindOutput()
        loginInstance?.delegate = self
        
        if #available(iOS 13.0, *) {
            appleButton.isEnabled = true
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability.startNotifier()
        AnalyticsManager.view_signIn.log()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
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
        
        loginViewStack.addArrangeSubviews([emailStackView, passwordStackView, loginButton])
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
        oAuthStackView.addArrangeSubviews([leftSpacing, facebookButton, naverButton, appleButton, rightSpacing])
        
        loginViewStack.snp.makeConstraints {
            $0.center.equalTo(view.layoutMarginsGuide)
        }
    }
    
    private func bindInput() {
        emailTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .share()
            .bind(to: viewModel.input.emailText)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .share()
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
            .subscribe(onNext: { [weak self] _ in
                AnalyticsManager.click_naver.log()
                let configuration = LoginConfiguration(
                    permissions: ["email"],
                    tracking: .enabled,
                    nonce: "123"
                )
                self?.facebookManager.logIn(configuration: configuration!, completion: { result in
                    switch result {
                    case .cancelled: break
                    case .failed(let error):
                        self?.viewModel.input.oAuthError.accept(error)
                    case .success:
                        Log.info("Facebook : \(String(describing: AuthenticationToken.current?.tokenString))")
                        if let token = AuthenticationToken.current?.tokenString {
                            self?.viewModel.input.facebookLoginSuccess.accept(token)
                        }
                    }
                })
            })
            .disposed(by: disposeBag)
        
        naverButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                AnalyticsManager.click_naver.log()
                self?.loginInstance?.requestThirdPartyLogin()
            })
            .disposed(by: disposeBag)
        
        kakaotalkButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                AnalyticsManager.click_kakaotalk.log()
                guard let session = KOSession.shared() else { return }
                
                if session.isOpen() {
                    session.close()
                }
                
                session.open(completionHandler: { error -> Void in
                    if !session.isOpen() {
                        if let error = error as NSError? {
                            switch error.code {
                            case Int(KOErrorCancelled.rawValue):
                                break
                            default:
                                print("오류")
                            }
                        }
                    } else {
                        if let token = session.token {
                            Log.info("Kakao : \(token)")
                            self?.viewModel.input.kakaotalkLoginSuccess.accept(token.accessToken)
                        }
                    }
                })
            })
            .disposed(by: disposeBag)
        
        if #available(iOS 13.0, *) {
            appleButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    AnalyticsManager.click_apple.log()
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                    let request = appleIDProvider.createRequest()
                    request.requestedScopes = [.fullName, .email]
                    
                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                    authorizationController.delegate = self
                    authorizationController.presentationContextProvider = self
                    authorizationController.performRequests()
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isEmailTyping
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.emailLine.backgroundColor = Colors.blue.color
                    self?.personImage.tintColor = Colors.blue.color
                } else {
                    self?.emailLine.backgroundColor = .gray
                    self?.personImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isPasswordTyping
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.passwordLine.backgroundColor = Colors.blue.color
                    self?.lockImage.tintColor = Colors.blue.color
                } else {
                    self?.passwordLine.backgroundColor = .gray
                    self?.lockImage.tintColor = Colors.black.color
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isPasswordEyed
            .map { !$0 }
            .bind(to: passwordTextField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        viewModel.output.loginButtonIsEnable
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.loginButton.isEnabled = bool
                    self?.loginButton.alpha = 1.0
                } else {
                    self?.loginButton.isEnabled = bool
                    self?.loginButton.alpha = 0.5
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
            .subscribe(onNext: { [weak self] _ in
                self?.emailTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] _ in
                self?.passwordTextField.resignFirstResponder()
            })
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
        self.view.frame.origin.y = 0
    }
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        sendNaverToken()
    }
    
    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    public func oauth20ConnectionDidFinishDeleteToken() {
        
    }
    
    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
    }
    
    private func sendNaverToken() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let accessToken = loginInstance?.accessToken else { return }
        self.viewModel.input.naverLoginSuccess.accept(accessToken)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let token = appleIDCredential.identityToken {
                print(token)
            }
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.viewModel.input.oAuthError.accept(error)
    }
}
