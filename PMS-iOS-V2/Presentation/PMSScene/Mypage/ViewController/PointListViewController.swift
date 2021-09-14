//
//  ScoreListViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then
import Reachability

final public class PointListViewController: UIViewController {
    internal let viewModel: PointListViewModel
    private let activityIndicator = UIActivityIndicatorView()
    private let reachability = try! Reachability()
    private let tableView = UITableView().then {
        $0.register(PointListTableViewCell.self, forCellReuseIdentifier: "PointListTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.separatorColor = .clear
        $0.rowHeight = 85
    }
    
    private let noPointView = MypageMessageView(title: .noPointListPlaceholder, label: .noPointListPlaceholder).then {
        $0.isHidden = true
    }
    
    private let disposeBag = DisposeBag()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ListSection<Point>>(configureCell: {  (_, tableView, _, point) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointListTableViewCell") as! PointListTableViewCell
        cell.setupView(model: point)
        cell.selectionStyle = .none
        return cell
    })
    
    public init(viewModel: PointListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = LocalizedString.pointListTitle.localized
        self.setupSubview()
        self.bindOutput()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
        AnalyticsManager.view_pointList.log()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubViews([tableView, noPointView, activityIndicator])
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.layoutMarginsGuide)
        }
        
        noPointView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        reachability.rx.isDisconnected
            .bind(to: viewModel.input.noInternet)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.tableView.deselectRow(at: index, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.pointList
            .map { [ListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.pointList
            .filter { $0.isEmpty == true }
            .subscribe(onNext: { [weak self] _ in
                self?.noPointView.isHidden = false
            }).disposed(by: disposeBag)
    }
}
