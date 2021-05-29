//
//  ChangePasswordViewTests.swift
//  PMS-iOS-V2Tests
//
//  Created by GoEun Jeong on 2021/05/29.
//

import RxCocoa
import RxSwift
import XCTest
import Moya

@testable import PMS_iOS_V2

class ChangePasswordViewTests: XCTestCase {
    let disposeBag = DisposeBag()
    var view: ChangePasswordViewController!
    var viewModel: ChangePasswordViewModel!
    
    // MARK: - GIVEN

    override func setUp() {
        let repository = DefaultChangePasswordRepository(provider: MoyaProvider<AuthApi>(stubClosure: { _ in .immediate }))
        viewModel = ChangePasswordViewModel(repository: repository)
        view = ChangePasswordViewController(viewModel: viewModel)
    }
    
    func test_active_now_password_Line() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isNowPasswordTyping.accept(true)
        XCTAssertEqual(view.nowPasswordLine.backgroundColor, Colors.blue.color)
        
        viewModel.output.isNowPasswordTyping.accept(false)
        XCTAssertEqual(view.nowPasswordLine.backgroundColor, UIColor.gray)
    }

    func test_active_new_password_Line() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isNewPasswordTyping.accept(true)
        XCTAssertEqual(view.newPasswordLine.backgroundColor, Colors.blue.color)
        
        viewModel.output.isNewPasswordTyping.accept(false)
        XCTAssertEqual(view.newPasswordLine.backgroundColor, UIColor.gray)
    }
    
    func test_active_re_new_passwordLine() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isReNewPasswordTyping.accept(true)
        XCTAssertEqual(view.reNewPasswordLine.backgroundColor, Colors.blue.color)
        
        viewModel.output.isReNewPasswordTyping.accept(false)
        XCTAssertEqual(view.reNewPasswordLine.backgroundColor, UIColor.gray)
    }
    
    func test_loginButton_enable() {
        
        // MARK: - WHEN
        
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.changePasswordButtonIsEnable.accept(true)
        XCTAssertEqual(view.changePasswordButton.isEnabled, true)
        XCTAssertEqual(view.changePasswordButton.alpha, 1)
        
        viewModel.output.changePasswordButtonIsEnable.accept(false)
        XCTAssertEqual(view.changePasswordButton.isEnabled, false)
        XCTAssertEqual(view.changePasswordButton.alpha, 0.5)
    }
    
    func test_activityIndicator_isLoading() {
        // MARK: - WHEN
        view.viewDidLoad()
        
        // MARK: - THEN
        
        viewModel.output.isLoading.accept(true)
        XCTAssertEqual(view.activityIndicator.isAnimating, true)
        
    }
}
