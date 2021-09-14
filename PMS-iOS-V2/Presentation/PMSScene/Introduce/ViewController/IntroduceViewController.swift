//
//  IntroduceViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift

final public class IntroduceViewController: UIViewController {
    @Inject internal var viewModel: IntroduceViewModel
    private let disposeBag = DisposeBag()
    
    private let subTitle = UILabel().then {
        $0.text = LocalizedString.introduceSubtitle.localized
        $0.textColor = Colors.blue.color
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let clubButton = IntroduceRow(title: .clubTitle, desc: .clubSubtitle)
    private let companyButton = IntroduceRow(title: .companyTitle, desc: .companySubtitle)
    private let developerButton = IntroduceRow(title: .developerTitle, desc: .developerSubtitle)
    
    private let clubTapped = UITapGestureRecognizer()
    private let companyTapped = UITapGestureRecognizer()
    private let developerTapped = UITapGestureRecognizer()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        self.setNavigationTitle(title: .introduceTitle, accessibilityLabel: .introduceTitle, isLarge: true)
        setupSubview()
        clubButton.addGestureRecognizer(clubTapped)
        companyButton.addGestureRecognizer(companyTapped)
        developerButton.addGestureRecognizer(developerTapped)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.view_introduce.log()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(subTitle)
        view.addSubViews([clubButton, companyButton, developerButton])
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.leading.equalToSuperview().offset(20)
        }
        
        clubButton.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp_bottomMargin).offset(UIFrame.height / 13.5)
            $0.width.equalTo(UIFrame.width - 70)
            $0.height.equalTo(105)
            $0.centerX.equalToSuperview()
        }
        
        companyButton.snp.makeConstraints {
            $0.top.equalTo(clubButton.snp_bottomMargin).offset(UIFrame.height / 13.5)
            $0.width.equalTo(UIFrame.width - 70)
            $0.height.equalTo(105)
            $0.centerX.equalToSuperview()
        }
        
        developerButton.snp.makeConstraints {
            $0.top.equalTo(companyButton.snp_bottomMargin).offset(UIFrame.height / 13.5)
            $0.width.equalTo(UIFrame.width - 70)
            $0.height.equalTo(105)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bindInput() {
        clubTapped.rx.event
            .map { _ in }
            .bind(to: viewModel.input.clubButtonTapped)
            .disposed(by: disposeBag)
        
        companyTapped.rx.event
            .map { _ in }
            .bind(to: viewModel.input.companyButtonTapped)
            .disposed(by: disposeBag)
        
        developerTapped.rx.event
            .map { _ in }
            .bind(to: viewModel.input.developerButtonTapped)
            .disposed(by: disposeBag)
    }
}
