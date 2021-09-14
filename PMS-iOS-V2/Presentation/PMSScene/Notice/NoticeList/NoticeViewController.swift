//
//  NoticeViewController.swift
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

final public class NoticeViewController: UIViewController {
    @Inject internal var viewModel: NoticeViewModel
    private let searchController = UISearchController(searchResultsController: nil)
    private let segmentedControl = UISegmentedControl(items: [LocalizedString.noticeTitle.localized, LocalizedString.letter.localized, LocalizedString.album.localized]).then {
        $0.contentMode = .scaleAspectFit
        $0.selectedSegmentIndex = 0
        $0.apportionsSegmentWidthsByContent = true
        $0.setWidth(100, forSegmentAt: 0)
        $0.setWidth(100, forSegmentAt: 1)
        $0.setWidth(100, forSegmentAt: 2)
    }
    private let activityIndicator = UIActivityIndicatorView()
    private let tableView = UITableView().then {
        $0.register(NoticeTableViewCell.self, forCellReuseIdentifier: "NoticeTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.separatorColor = .clear
        $0.rowHeight = 70
    }
    private let previousButton = PreviousPageButton(label: .previousPageButton)
    private let nextButton = NextPageButton(label: .nextPageButton)
    private let pageLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    private let pageStackView = UIStackView().then {
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    private let noNoticeView = MypageMessageView(title: .noNoticeListPlaceholder, label: .noNoticeListPlaceholder).then {
        $0.isHidden = true
    }
    
    private let disposeBag = DisposeBag()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ListSection<NoticeCell>>(configureCell: {  (_, tableView, _, notice) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell") as! NoticeTableViewCell
        cell.setupView(model: notice)
        cell.selectionStyle = .none
        return cell
    })
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        self.setNavigationTitle(title: .noticeTitle, accessibilityLabel: .noticeTitle, isLarge: true)
        self.navigationItem.searchController = searchController
        self.setupSubview()
        self.bindOutput()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubViews([segmentedControl, tableView, noNoticeView, pageStackView])
        view.addSubview(activityIndicator)
        pageStackView.addArrangeSubviews([previousButton, pageLabel, nextButton])
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalToSuperview().offset(-35)
        }
        
        noNoticeView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp_bottomMargin).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 50)
            $0.bottom.equalTo(pageStackView.snp_topMargin).offset(-20)
        }
        
        pageStackView.snp.makeConstraints {
            $0.width.equalTo(UIFrame.width / 4)
            $0.height.equalTo(15)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.layoutMarginsGuide).offset(-20)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .filter { $0 != "" }
            .debounce(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { [weak self] text in
                self?.pageStackView.isHidden = true
                return text
            }
            .bind(to: viewModel.input.searchText)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .filter { $0 == "" }
            .subscribe { [weak self] _ in
                self?.viewModel.input.viewDidLoad.accept(())
                self?.pageStackView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .bind(to: viewModel.input.segmentControl)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(NoticeCell.self)
            .bind(to: viewModel.input.goNoticeDetail)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.tableView.deselectRow(at: index, animated: true)
            })
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .bind(to: viewModel.input.previousPageTapped)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: viewModel.input.nextPageTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.page
            .subscribe { [weak self] page in
                self?.pageLabel.text = String(page)
            }.disposed(by: disposeBag)
        
        viewModel.output.noticeList
            .map { [ListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.noticeList
            .subscribe(onNext: { [weak self] notice in
                self?.noNoticeView.isHidden = !notice.isEmpty
            }).disposed(by: disposeBag)
    }
}
