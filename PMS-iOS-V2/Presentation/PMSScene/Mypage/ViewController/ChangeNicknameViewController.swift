//
//  ChangeNicknameViewContrroller.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit
import RxSwift
import RxCocoa

class ChangeNicknameViewController: UIViewController {
    let viewModel: ChangeNicknameViewModel
    private let delegate: ChangeNicknameDelegate
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
        $0.setTitleColor(Colors.red.color, for: .normal)
        $0.setTitle(.cancel)
    }
    
    let changeButton = UIButton().then {
        $0.setTitleColor(Colors.blue.color, for: .normal)
        $0.setTitle(.confirm)
    }
    
    let nicknameStackView = UIStackView().then {
        $0.spacing = 5.0
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    let nicknameLine = UIView().then {
        $0.backgroundColor = .gray
    }
    
    let nicknameTextField = PMSTextField(title: .newNicknamePlaceholder)
    
    init(viewModel: ChangeNicknameViewModel,
         delegate: ChangeNicknameDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupSubview()
        self.bindOutput()
        self.setDelegate()
    }
    
    private func setupSubview() {
        view.backgroundColor = .clear
        view.addSubview(whiteBackground)
        whiteBackground.addSubViews([nicknameStackView, confirmLine, cancelButton, changeButton])
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
        
        nicknameStackView.addArrangeSubviews([nicknameTextField, nicknameLine])
        
        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(whiteBackground.snp_topMargin).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        nicknameLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 120)
        }
        
        confirmLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(UIFrame.width - 80)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nicknameLine.snp_topMargin).offset(30)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(confirmLine.snp_bottomMargin).offset(30)
            $0.leading.equalToSuperview().offset(UIFrame.width / 6)
        }
        
        changeButton.snp.makeConstraints {
            $0.centerY.equalTo(cancelButton)
            $0.trailing.equalToSuperview().offset(-UIFrame.width / 6)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        nicknameTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: {
                self.delegate.dismissChangeNickname()
            }).disposed(by: disposeBag)
        
        changeButton.rx.tap
            .subscribe(onNext: {
                self.delegate.dismissChangeNickname()
                self.viewModel.input.changeButtonTapped.accept(())
                self.delegate.success()
            }).disposed(by: disposeBag)
        
    }
    
    private func bindOutput() {
        viewModel.output.isNicknameTyping
            .subscribe(onNext: {
                if $0 {
                    self.nicknameLine.backgroundColor = Colors.blue.color
                } else {
                    self.nicknameLine.backgroundColor = .gray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.changeButtonIsEnable
            .subscribe(onNext: {
                if $0 {
                    self.changeButton.isEnabled = $0
                    self.changeButton.alpha = 1.0
                } else {
                    self.changeButton.isEnabled = $0
                    self.changeButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setDelegate() {
        nicknameTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.nicknameTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
    }
}
