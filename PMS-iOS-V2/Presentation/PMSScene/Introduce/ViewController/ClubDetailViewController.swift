//
//  ClubDetailViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import Reachability
import RxSwift
import RxCocoa

public final class ClubDetailViewController: UIViewController {
    @Inject internal var viewModel: ClubViewModel
    private let name: String
    private let activityIndicator = UIActivityIndicatorView()
    private let reachability = try! Reachability()
    private let disposeBag = DisposeBag()
    private let detailView = ClubDetailView()
    
    public init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = name
        self.setupSubview()
        self.bindOutput()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(detailView)
        
        detailView.snp.makeConstraints {
            $0.edges.equalTo(view.layoutMarginsGuide)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
        AnalyticsManager.view_club_detail.log(name: name)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .map { _ in return self.name }
            .bind(to: viewModel.input.getDetailClub)
            .disposed(by: disposeBag)
        
        reachability.rx.isDisconnected
            .bind(to: viewModel.input.noInternet)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.detailClub
            .subscribe { [weak self] club in
                self?.detailView.setupView(model: club)
            }.disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
