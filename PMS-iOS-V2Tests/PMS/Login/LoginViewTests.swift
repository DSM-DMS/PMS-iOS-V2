//
//  LoginViewTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/21.
//

import RxCocoa
import RxSwift
import XCTest
import Moya

@testable import PMS_iOS_V2

class LoginViewTests: XCTestCase {
    let disposeBag = DisposeBag()
    var view: LoginViewController!
    var viewModel: LoginViewModel!
    
    // MARK: - GIVEN
    
    override func setUp() {
        let repository = DefaultLoginRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = LoginViewModel(repository: repository)
        view = LoginViewController(viewModel: viewModel)
    }
    
    func test_active_passwordEyeImage() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.passwordEyeVisiable.accept(true)
        XCTAssertEqual(view.passwordEyeButton.isHidden, false)
        
        viewModel.output.passwordEyeVisiable.accept(false)
        XCTAssertEqual(view.passwordEyeButton.isHidden, true)
    }
    
    func test_active_emailLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isEmailTyping.accept(true)
        XCTAssertEqual(view.emailLine.backgroundColor, Colors.blue.color)
        
        viewModel.output.isEmailTyping.accept(false)
        XCTAssertEqual(view.emailLine.backgroundColor, UIColor.gray)
    }
    
    func test_active_passwordLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isPasswordTyping.accept(true)
        XCTAssertEqual(view.passwordLine.backgroundColor, Colors.blue.color)
        
        viewModel.output.isPasswordTyping.accept(false)
        XCTAssertEqual(view.passwordLine.backgroundColor, UIColor.gray)
    }
    
    func test_loginButton_enable() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.loginButtonIsEnable.accept(true)
        XCTAssertEqual(view.loginButton.isEnabled, true)
        XCTAssertEqual(view.loginButton.alpha, 1)
        
        viewModel.output.loginButtonIsEnable.accept(false)
        XCTAssertEqual(view.loginButton.isEnabled, false)
        XCTAssertEqual(view.loginButton.alpha, 0.5)
    }
    
    func test_activityIndicator_isLoading() {
        // MARK: - WHEN
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isLoading.accept(true)
        XCTAssertEqual(view.activityIndicator.isAnimating, true)
    }
}
