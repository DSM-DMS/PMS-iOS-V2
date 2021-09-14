//
//  AddStudentViewControllerr.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit
import RxSwift
import RxCocoa

final public class AddStudentViewController: UIViewController {
    @Inject internal var viewModel: AddStudentViewModel
    private let dismiss: () -> Void
    private let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    private let whiteBackground = UIView().then {
        $0.backgroundColor = Colors.whiteGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = Colors.gray.color.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private let confirmLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitleColor(Colors.red.color, for: .normal)
        $0.setTitle(.cancel)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let addButton = UIButton().then {
        $0.setTitleColor(Colors.blue.color, for: .normal)
        $0.setTitle(.confirm)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let otpFieldView = OTPFieldView()
    
    private let textLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        $0.text = LocalizedString.enterStudentCodeMsg.localized
    }
    
    internal init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
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
            $0.height.equalTo(170)
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
            $0.top.equalTo(confirmLine.snp_bottomMargin).offset(20)
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
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss()
            }).disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: viewModel.input.addButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        
        viewModel.output.addButtonIsEnable
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.addButton.isEnabled = bool
                    self?.addButton.alpha = 1.0
                } else {
                    self?.addButton.isEnabled = bool
                    self?.addButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isSucceed
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.dismiss()
                } else {
                    self?.otpFieldView.shake()
                }
            }).disposed(by: disposeBag)
        
    }
}

extension AddStudentViewController: OTPFieldViewDelegate {
    public func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    public func enteredOTP(otp: String) {
        self.viewModel.input.otpString.accept(otp)
    }
    
    public func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        return true
    }
    
    public func deletedOTP() {
        
    }
    
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
