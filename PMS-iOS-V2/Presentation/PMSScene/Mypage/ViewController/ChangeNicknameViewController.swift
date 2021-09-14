//
//  ChangeNicknameViewContrroller.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit
import RxSwift
import RxCocoa

final public class ChangeNicknameViewController: UIViewController {
    @Inject internal var viewModel: ChangeNicknameViewModel
    private let delegate: ChangeNicknameDelegate
    private let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    let whiteBackground = UIView().then {
        $0.backgroundColor = Colors.whiteGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = Colors.gray.color.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    let confirmLine = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let cancelButton = UIButton().then {
        $0.setTitleColor(Colors.red.color, for: .normal)
        $0.setTitle(.cancel)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    let changeButton = UIButton().then {
        $0.setTitleColor(Colors.blue.color, for: .normal)
        $0.setTitle(.confirm)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
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
    
    init(delegate: ChangeNicknameDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
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
            $0.height.equalTo(170)
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
            $0.top.equalTo(confirmLine.snp_bottomMargin).offset(20)
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
            .debounce(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.nicknameText)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate.dismissChangeNickname()
            }).disposed(by: disposeBag)
        
        changeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate.dismissChangeNickname()
                self?.viewModel.input.changeButtonTapped.accept(())
                self?.delegate.success()
            }).disposed(by: disposeBag)
        
    }
    
    private func bindOutput() {
        viewModel.output.isNicknameTyping
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.nicknameLine.backgroundColor = Colors.blue.color
                } else {
                    self?.nicknameLine.backgroundColor = .gray
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.changeButtonIsEnable
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.changeButton.isEnabled = bool
                    self?.changeButton.alpha = 1.0
                } else {
                    self?.changeButton.isEnabled = bool
                    self?.changeButton.alpha = 0.5
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setDelegate() {
        nicknameTextField.rx.shouldReturn
            .subscribe(onNext: { [weak self] _ in
                self?.nicknameTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}
