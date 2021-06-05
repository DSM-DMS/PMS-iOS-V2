//
//  RegisterrViewTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/22.
//

import RxCocoa
import RxSwift
import XCTest
import Moya

@testable import PMS_iOS_V2

class RegisterViewTests: XCTestCase {
    let disposeBag = DisposeBag()
    var view: RegisterViewController!
    var viewModel: RegisterViewModel!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultRegisterRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = RegisterViewModel(repository: repository)
        view = RegisterViewController(viewModel: viewModel)
    }
    
    func test_active_nicknameLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isNicknameTyping.accept(true)
        XCTAssertEqual(view.nicknameLine.backgroundColor, Colors.red.color)
        
        viewModel.output.isNicknameTyping.accept(false)
        XCTAssertEqual(view.nicknameLine.backgroundColor, UIColor.gray)
    }

    func test_active_emailLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isEmailTyping.accept(true)
        XCTAssertEqual(view.emailLine.backgroundColor, Colors.red.color)
        
        viewModel.output.isEmailTyping.accept(false)
        XCTAssertEqual(view.emailLine.backgroundColor, UIColor.gray)
    }
    
    func test_active_passwordLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isPasswordTyping.accept(true)
        XCTAssertEqual(view.passwordLine.backgroundColor, Colors.red.color)
        
        viewModel.output.isPasswordTyping.accept(false)
        XCTAssertEqual(view.passwordLine.backgroundColor, UIColor.gray)
    }
    
    func test_active_rePasswordLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isRePasswordTyping.accept(true)
        XCTAssertEqual(view.rePasswordLine.backgroundColor, Colors.red.color)
        
        viewModel.output.isRePasswordTyping.accept(false)
        XCTAssertEqual(view.rePasswordLine.backgroundColor, UIColor.gray)
    }
    
    func test_loginButton_enable() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.registerButtonIsEnable.accept(true)
        XCTAssertEqual(view.registerButton.isEnabled, true)
        XCTAssertEqual(view.registerButton.alpha, 1)
        
        viewModel.output.registerButtonIsEnable.accept(false)
        XCTAssertEqual(view.registerButton.isEnabled, false)
        XCTAssertEqual(view.registerButton.alpha, 0.5)
    }
    
    func test_activityIndicator_isLoading() {
        // MARK: - WHEN
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isLoading.accept(true)
        XCTAssertEqual(view.activityIndicator.isAnimating, true)
        
    }
}
