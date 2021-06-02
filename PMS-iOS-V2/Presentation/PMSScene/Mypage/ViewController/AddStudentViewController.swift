//
//  AddStudentViewControllerr.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit
import RxSwift
import RxCocoa

class AddStudentViewController: UIViewController {
    let viewModel: AddStudentViewModel
    let dismiss: () -> Void
    let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    let whiteBackground = UIView().then {
        $0.backgroundColor = Colors.white.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    let confirmLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let cancelButton = UIButton().then {
        $0.setTitleColor(.red, for: .normal)
        $0.setTitle(.cancel)
    }
    
    let addButton = UIButton().then {
        $0.setTitleColor(.blue, for: .normal)
        $0.setTitle(.confirm)
    }
    
    let otpFieldView = OTPFieldView()
    
    let textLabel = UILabel().then {
        $0.text = LocalizedString.enterStudentCodeMsg.localized
    }
    
    init(viewModel: AddStudentViewModel,
         dismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.dismiss = dismiss
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupSubview()
        self.bindOutput()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.otpFieldView.baseStyle()
        }
        otpFieldView.delegate = self
    }
    
    private func setupSubview() {
        view.backgroundColor = .clear
        view.addSubview(whiteBackground)
        whiteBackground.addSubViews([textLabel, otpFieldView, confirmLine, cancelButton, addButton])
        view.addSubview(activityIndicator)
        
        self.view.snp.makeConstraints {
            $0.height.equalTo(UIFrame.height / 5.5)
            $0.width.equalTo(UIFrame.width - 50)
        }
        
        whiteBackground.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(whiteBackground.snp_topMargin).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        otpFieldView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp_bottomMargin).offset(10)
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
            $0.leading.equalToSuperview()
        }
        
        confirmLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 80)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(otpFieldView.snp_bottomMargin).offset(30)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(confirmLine.snp_bottomMargin).offset(30)
            $0.leading.equalToSuperview().offset(UIFrame.width / 6)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.trailing.equalToSuperview().offset(-UIFrame.width / 6)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss()
            }).disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.input.addButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        
        viewModel.output.addButtonIsEnable
            .subscribe(onNext: {
                if $0 {
                    self.addButton.isEnabled = $0
                    self.addButton.alpha = 1.0
                } else {
                    self.addButton.isEnabled = $0
                    self.addButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isSucceed
            .subscribe(onNext: {
                if $0 {
                    self.otpFieldView.isValidOtp = true
                    self.dismiss()
                } else {
                    self.otpFieldView.isValidOtp = false
                }
            }) .disposed(by: disposeBag)
        
    }
}

extension AddStudentViewController: OTPFieldViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp: String) {
        self.viewModel.input.otpString.accept(otp)
    }
    
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return true
    }
    
    func deletedOTP() {
        
    }
    
}
