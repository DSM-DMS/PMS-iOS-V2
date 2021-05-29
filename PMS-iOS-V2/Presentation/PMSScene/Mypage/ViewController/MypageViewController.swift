//
//  MypageViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController {
    let viewModel: MypageViewModel
    private let disposeBag = DisposeBag()
    
    private let blueBackground = UIView().then {
        $0.backgroundColor = Colors.blue.color
    }
    
    private let nickNameStackView = UIStackView().then {
        $0.spacing = 10.0
    }
    
    private let nickNameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.text = "닉네임"
    }
    
    private let pencilImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Asset.whitePencil.image
    }
    
    private let studentStackView = UIStackView().then {
        $0.spacing = 10.0
    }
    private let studentLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.text = "학생 추가"
    }
    private let downArrowImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Asset.bottomArrow.image
    }
    
    private let mypageStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 25.0
    }
    
    private let pointStackView = UIStackView().then {
        $0.distribution = .equalSpacing
    }
    private let plusPointRow = PlusPointRow()
    private let minusPointRow = MinusPointRow()
    private let statusView = StatusView()
    private let outingListButton = MypageButton(title: .toOutingList, label: .toOutingListButton)
    private let changePasswordButton = MypageButton(title: .toChangePassword, label: .toChangePasswordButton)
    private let logoutButton = MypageButton(title: .toLogout, label: .toLogoutButton)
    
    init(viewModel: MypageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupSubview()
        self.bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(blueBackground)
        view.addSubViews([nickNameStackView, studentStackView])
        view.addSubview(mypageStackView)
        mypageStackView.addArrangeSubviews([pointStackView, statusView, outingListButton, changePasswordButton, logoutButton])
        
        blueBackground.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(pointStackView.snp_bottomMargin).offset(-15)
        }
        
        nickNameStackView.addArrangeSubviews([nickNameLabel, pencilImage])
        
        nickNameStackView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide).offset(UIFrame.height / 17)
            $0.leading.equalToSuperview().offset(40)
        }
        
        pencilImage.snp.makeConstraints {
            $0.width.height.equalTo(25)
        }
        
        studentStackView.addArrangeSubviews([studentLabel, downArrowImage])
        
        studentStackView.snp.makeConstraints {
            $0.centerY.equalTo(nickNameStackView)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        downArrowImage.snp.makeConstraints {
            $0.width.height.equalTo(15)
        }
        
        mypageStackView.snp.makeConstraints {
            $0.top.equalTo(nickNameStackView.snp_bottomMargin).offset(40)
            $0.width.equalTo(UIFrame.width - 70)
            $0.centerX.equalToSuperview()
        }
        
        pointStackView.addArrangeSubviews([plusPointRow, minusPointRow])
        
        pointStackView.snp.makeConstraints {
            $0.height.equalTo(80)
        }
        
        plusPointRow.snp.makeConstraints {
            $0.width.equalTo(UIFrame.width / 2 - 50)
        }
        
        minusPointRow.snp.makeConstraints {
            $0.width.equalTo(UIFrame.width / 2 - 50)
        }
        
        statusView.snp.makeConstraints {
            $0.height.equalTo(140)
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        outingListButton.rx.tap
            .bind(to: viewModel.input.outingListButtonTapped)
            .disposed(by: disposeBag)
        
        changePasswordButton.rx.tap
            .bind(to: viewModel.input.chanegePasswordButtonTapped)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(to: viewModel.input.logoutButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        
    }
}
