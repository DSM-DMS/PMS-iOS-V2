//
//  StudentListViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then
import Reachability

final public class StudentListViewController: UIViewController {
    @Inject internal var viewModel: StudentListViewModel
    private let delegate: StudentListDelegate
    private let activityIndicator = UIActivityIndicatorView()
    private let reachability = try! Reachability()
    
    private let addButtonTapped = UITapGestureRecognizer()
    
    private let addStudentButton = CirclePlusButton()
    
    private let addStudentLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.text = LocalizedString.addStudentButton.localized
        $0.textAlignment = .left
        $0.isUserInteractionEnabled = true
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let tableView = UITableView().then {
        $0.register(UserStudentTableViewCell.self, forCellReuseIdentifier: "UserStudentTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.rowHeight = 60
        $0.backgroundColor = Colors.whiteGray.color
    }
    
    private let line = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ListSection<UsersStudent>>(configureCell: {  (_, tableView, _, student) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserStudentTableViewCell") as! UserStudentTableViewCell
        cell.setupView(model: student)
        cell.delegate = self.delegate
        return cell
    }, canEditRowAtIndexPath: { _, _ in return true })
    
    public init(delegate: StudentListDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        addStudentLabel.addGestureRecognizer(addButtonTapped)
        self.setupSubview()
        self.bindOutput()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.whiteGray.color
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 1.0
        view.layer.shadowColor = Colors.gray.color.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.masksToBounds = true
        view.addSubViews([tableView, addStudentButton, addStudentLabel, line, activityIndicator])
        
        tableView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 70)
            $0.height.equalTo(UIFrame.height / 4)
        }
        
        addStudentButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(35)
            $0.bottom.equalToSuperview().offset(-AppDelegate.window!.safeAreaInsets.bottom)
            $0.width.height.equalTo(25)
        }
        
        addStudentLabel.snp.makeConstraints {
            $0.leading.equalTo(addStudentButton.snp_trailingMargin).offset(20)
            $0.centerY.equalTo(addStudentButton)
            $0.width.equalTo(UIFrame.width - 105)
            $0.height.equalTo(30)
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(3)
            $0.width.equalTo(75)
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
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
        
        tableView.rx.modelSelected(UsersStudent.self)
            .subscribe(onNext: { [weak self] student in
                self?.delegate.changeStudent(student: student)
                UDManager.shared.student = String(student.number) + " " + student.name
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] students in
                guard let self = self else { return }
                self.delegate.delete(
                    student: self.viewModel.output.studentList.value[students[1]])
            })
            .disposed(by: disposeBag)
        
        addButtonTapped.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.delegate.addStudentTapped()
            })
            .disposed(by: disposeBag)
        
        addStudentButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate.addStudentTapped()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.studentList
            .map { [ListSection(header: "", items: $0)] }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
