//
//  NoticeDetailViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

class NoticeDetailViewController: UIViewController {
    let viewModel: NoticeDetailViewModel
    let activityIndicator = UIActivityIndicatorView()
    
    private let noticeView = NoticeDetailView()
    
    private let commentTableView = UITableView().then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.separatorColor = .clear
        $0.rowHeight = 70
    }
    
    private let disposeBag = DisposeBag()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ListSection<Comment>>(configureCell: {  (_, tableView, _, notice) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.setupView(model: notice)
        return cell
    })
    
    init(viewModel: NoticeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = viewModel.title
        self.setupSubview()
        self.bindOutput()
    }
    
    private func setupSubview() { // height
        view.backgroundColor = Colors.white.color
        view.addSubViews([noticeView, commentTableView])
        
        noticeView.snp.makeConstraints {
            $0.height.equalTo(UIFrame.height / 3)
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 50)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp_bottomMargin).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 50)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.detailNotice
            .subscribe {
                self.noticeView.setupView(model: $0)
            }.disposed(by: disposeBag)
        
        viewModel.output.detailNotice
            .map { [ListSection(header: "", items: $0.comment)] }
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
