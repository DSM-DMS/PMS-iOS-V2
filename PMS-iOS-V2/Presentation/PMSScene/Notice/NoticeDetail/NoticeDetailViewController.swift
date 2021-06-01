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
import Reachability

class NoticeDetailViewController: UIViewController {
    let viewModel: NoticeDetailViewModel
    private let reachability = try! Reachability()
    let activityIndicator = UIActivityIndicatorView()
    
    private let noticeView = NoticeDetailView()
    
    private let commentTableView = UITableView().then {
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.separatorColor = .clear
        $0.rowHeight = 70
        $0.allowsSelection = false
    }
    
    private let inputBackground = UIView().then {
        $0.backgroundColor = Colors.white.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 5
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private let mentionButton = MentionButton()
    private let enterButton = EnterButton()
    let commentTextField = UITextField().then {
        $0.setPlaceholder(.commentPlaceholder)
    }
    private let commentBackground = UIView().then {
        $0.backgroundColor = Colors.gray.color
        $0.layer.cornerRadius = 15
    }
    
    let mentionTableView = UITableView().then {
        $0.register(MentionTableViewCell.self, forCellReuseIdentifier: "MentionTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.rowHeight = 50
        $0.isHidden = true
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 5
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 15
    }
    
    private let disposeBag = DisposeBag()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<ListSection<Comment>>(configureCell: {  (_, tableView, _, notice) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        cell.setupView(model: notice)
        return cell
    })
    
    private let mentionDataSource = RxTableViewSectionedReloadDataSource<ListSection<Mention>>(configureCell: {  (_, tableView, _, mention) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionTableViewCell") as! MentionTableViewCell
        cell.setupView(text: mention.text)
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
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = viewModel.title
        self.setupSubview()
        self.bindOutput()
        self.setDelegate()
        self.addKeyboardNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    override func viewDidLayoutSubviews() {
        inputBackground.snp.makeConstraints {
            $0.height.equalTo(80 + view.safeAreaInsets.bottom / 2)
        }
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubViews([noticeView, commentTableView])
        view.addSubview(mentionTableView)
        view.addSubViews([inputBackground])
        view.addSubViews([mentionButton, commentBackground, commentTextField, enterButton])
        view.addSubview(activityIndicator)
        
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
        
        mentionButton.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalTo(20)
            $0.height.equalTo(25)
        }
        
        commentBackground.snp.makeConstraints {
            $0.centerX.equalTo(inputBackground)
            $0.bottom.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(50)
            $0.leading.equalTo(mentionButton.snp_trailingMargin).offset(20)
            $0.trailing.equalTo(enterButton.snp_leadingMargin).offset(-20)
        }
        
        commentTextField.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.height.equalTo(30)
            $0.leading.equalTo(commentBackground.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(enterButton.snp_leadingMargin).offset(-20)
        }
        
        enterButton.snp.makeConstraints {
            $0.centerY.equalTo(commentBackground)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.equalTo(20)
            $0.height.equalTo(15)
        }
        
        inputBackground.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        mentionTableView.snp.makeConstraints {
            $0.bottom.equalTo(inputBackground.snp_topMargin)
            $0.width.equalToSuperview()
            $0.height.equalTo(UIFrame.height / 4.5)
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
        
        commentTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.input.commentText)
            .disposed(by: disposeBag)
        
        commentTextField.rx.text
            .orEmpty
            .map { if $0.contains("@") { return true } else { return false }}
            .subscribe { 
                self.popUpMentionView(popUp: $0)
            }
            .disposed(by: disposeBag)
        
        mentionButton.rx.tap
            .subscribe { _ in
                self.commentTextField.text?.append("@")
            }
            .disposed(by: disposeBag)
        
        enterButton.rx.tap
            .bind(to: viewModel.input.enterButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.detailNotice
            .subscribe {
                self.noticeView.setupView(model: $0)
            }.disposed(by: disposeBag)
        
        viewModel.output.detailNotice
            .map { [ListSection(header: "", items: $0.comment)] }
            .bind(to: commentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.just([Mention(text: "테스트"), Mention(text: "테스트1"), Mention(text: "테스트2")])
            .map { [ListSection(header: "", items: $0)] }
            .bind(to: mentionTableView.rx.items(dataSource: mentionDataSource))
            .disposed(by: disposeBag)
    }
    
    private func setDelegate() {
        commentTextField.rx.shouldReturn
            .subscribe(onNext: { _ in self.commentTextField.resignFirstResponder() })
            .disposed(by: disposeBag)
    }
    
    private func popUpMentionView(popUp: Bool) {
        if popUp {
            mentionTableView.isHidden = false
        } else {
            mentionTableView.isHidden = true
        }
    }
}

extension NoticeDetailViewController {
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if self.view.frame.origin.y == 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height
                self.view.frame.origin.y -= keyboardHeight
            }
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if self.view.frame.origin.y != 0 {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keybaordRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keybaordRectangle.height
                self.view.frame.origin.y += keyboardHeight
            }
        }
    }
}
