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

class ClubDetailViewController: UIViewController {
    let viewModel: ClubViewModel
    let name: String
    private let reachability = try! Reachability()
    private let disposeBag = DisposeBag()
    
    init(viewModel: ClubViewModel, name: String) {
        self.viewModel = viewModel
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = LocalizedString.clubTitle.localized
        self.setupSubview()
        self.bindOutput()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
//        viewModel.output.clubList
//            .map { [ListSection<ClubDetail>(header: "", items: $0)] }
//            .bind(to: collectionView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
}
