//
//  MypageViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa

public class MypageViewController: UIViewController {
    @Inject internal var viewModel: MypageViewModel!
    private let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    public let pointTapped = UITapGestureRecognizer()
    public let nicknameTapped = UITapGestureRecognizer()
    public let studentTapped = UITapGestureRecognizer()
    public let backgroundTapped = UITapGestureRecognizer()
    public lazy var changeNicknameView = ChangeNicknameViewController(
        delegate: self).then {
            $0.view.isHidden = true
        }
    
    public lazy var studentListView = StudentListViewController(
        delegate: self).then {
            $0.view.isHidden = true
        }
    
    public lazy var addStudentView = AddStudentViewController(
        dismiss: {
            self.dismissAddStudent()
        }).then {
            $0.view.isHidden = true
        }
    
    public lazy var blackBackground = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.2
        $0.isHidden = true
    }
    
    private let blueBackground = UIView().then {
        $0.backgroundColor = Colors.blue.color
    }
    
    private let nickNameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        $0.text = "닉네임"
        $0.isUserInteractionEnabled = true
    }
    
    private let pencilImage = WhitePencilButton()
    
    private let studentLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.isUserInteractionEnabled = true
        $0.text = "학생 추가"
    }
    private let downArrowImage = BottomArrowButton()
    
    private let mypageStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 25.0
    }
    
    private let noStudentView = MypageMessageView(title: .noStudentPlaceholder, label: .noStudentPlaceholder).then {
        $0.isHidden = true
    }
    private let noLoginView = MypageMessageView(title: .noAuthPlaceholder, label: .noAuthPlaceholder).then {
        $0.isHidden = true
    }
    
    private let pointStackView = UIStackView().then {
        $0.distribution = .equalSpacing
    }
    private let plusPointRow = PlusPointRow()
    private let minusPointRow = MinusPointRow()
    private let statusView = StatusView()
    private let outingListButton = MypageRow(title: .toOutingList, label: .toOutingListButton)
    private let changePasswordButton = MypageRow(title: .toChangePassword, label: .toChangePasswordButton)
    private let logoutButton = MypageRow(title: .toLogout, label: .toLogoutButton)
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        self.setupSubview()
        self.bindOutput()
        pointStackView.addGestureRecognizer(pointTapped)
        nickNameLabel.addGestureRecognizer(nicknameTapped)
        studentLabel.addGestureRecognizer(studentTapped)
        blackBackground.addGestureRecognizer(backgroundTapped)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        AnalyticsManager.view_mypage.log()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(blueBackground)
        view.addSubViews([nickNameLabel, pencilImage, studentLabel, downArrowImage])
        view.addSubViews([noStudentView, noLoginView])
        view.addSubview(mypageStackView)
        mypageStackView.addArrangeSubviews([pointStackView, noStudentView, noLoginView, statusView, outingListButton, changePasswordButton, logoutButton])
        view.addSubview(activityIndicator)
        view.addSubViews([blackBackground, changeNicknameView.view, studentListView.view, addStudentView.view])
        
        blueBackground.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(pointStackView.snp_bottomMargin).offset(-15)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide).offset(UIFrame.height / 17)
            $0.leading.equalToSuperview().offset(40)
        }
        
        pencilImage.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel)
            $0.leading.equalTo(nickNameLabel.snp_trailingMargin).offset(20)
            $0.width.height.equalTo(20)
        }
        
        studentLabel.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel)
            $0.trailing.equalTo(downArrowImage.snp_leadingMargin).offset(-20)
        }
        
        downArrowImage.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel)
            $0.trailing.equalToSuperview().offset(-40)
            $0.width.height.equalTo(15)
        }
        
        mypageStackView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp_bottomMargin).offset(40)
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
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        blackBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        changeNicknameView.view.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        studentListView.view.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(UIFrame.height / 3)
        }
        
        addStudentView.view.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        backgroundTapped.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.changeNicknameView.view.isHidden = true
                if self != nil && self!.addStudentView.view.isHidden {
                    self?.studentListView.view.isHidden = true
                    self?.blackBackground.isHidden = true
                    self?.viewModel.input.backgroundTapped.accept(())
                } else {
                    self?.addStudentView.view.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        pencilImage.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.blackBackground.isHidden = false
                self?.changeNicknameView.view.isHidden = false
                self?.viewModel.input.changeNicknameButtonTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        nicknameTapped.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.blackBackground.isHidden = false
                self?.changeNicknameView.view.isHidden = false
                self?.viewModel.input.changeNicknameButtonTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        downArrowImage.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.blackBackground.isHidden = false
                self?.studentListView.view.isHidden = false
                self?.viewModel.input.studentListButtonTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        studentTapped.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.blackBackground.isHidden = false
                self?.studentListView.view.isHidden = false
                self?.viewModel.input.studentListButtonTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        pointTapped.rx.event
            .map { _ in }
            .bind(to: viewModel.input.pointListButtonTapped)
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
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.nickName
            .subscribe(onNext: { [weak self] name in
                self?.nickNameLabel.text = name
            }).disposed(by: disposeBag)
        
        viewModel.output.studentName
            .subscribe (onNext: { [weak self] name in
                self?.studentLabel.text = name
            }).disposed(by: disposeBag)
        
        viewModel.output.isNoLogin
            .subscribe(onNext: { [weak self] bool in
                self?.ifNoLoginChangeVisible(bool)
            }).disposed(by: disposeBag)
        
        viewModel.output.isStudent
            .subscribe(onNext: { [weak self] bool in
                if self != nil && self!.viewModel.output.isNoLogin.value {
                    self?.noStudentView.isHidden = true
                } else if bool {
                    self?.statusView.isHidden = false
                    self?.noStudentView.isHidden = true
                    self?.outingListButton.isHidden = false
                } else {
                    self?.plusPointRow.setupView(plus: 0)
                    self?.minusPointRow.setupView(minus: 0)
                    self?.studentLabel.text = "학생 추가"
                    self?.statusView.isHidden = true
                    self?.noStudentView.isHidden = false
                    self?.outingListButton.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.studentStatus
            .subscribe(onNext: { [weak self] student in
                self?.statusView.setupView(model: student)
                self?.plusPointRow.setupView(plus: student.plus)
                self?.minusPointRow.setupView(minus: student.minus)
            }).disposed(by: disposeBag)
    }
    
    private func ifNoLoginChangeVisible(_ isNoLogin: Bool) {
        if isNoLogin {
            self.statusView.isHidden = true
            self.changePasswordButton.isHidden = true
            self.noLoginView.isHidden = false
            self.studentLabel.alpha = 0.5
            self.downArrowImage.alpha = 0.5
            self.nickNameLabel.alpha = 0.5
            self.pencilImage.alpha = 0.5
            self.studentTapped.isEnabled = false
            self.downArrowImage.isEnabled = false
            self.nicknameTapped.isEnabled = false
            self.pencilImage.isEnabled = false
            self.outingListButton.isHidden = true
        } else {
            self.statusView.isHidden = false
            self.changePasswordButton.isHidden = false
            self.noLoginView.isHidden = true
            self.studentLabel.alpha = 1
            self.downArrowImage.alpha = 1
            self.nickNameLabel.alpha = 1
            self.pencilImage.alpha = 1
            self.studentTapped.isEnabled = true
            self.downArrowImage.isEnabled = true
            self.nicknameTapped.isEnabled = true
            self.pencilImage.isEnabled = true
            self.outingListButton.isHidden = false
        }
    }
}

extension MypageViewController: ChangeNicknameDelegate {
    public func dismissChangeNickname() {
        self.blackBackground.isHidden = true
        self.changeNicknameView.view.isHidden = true
        self.viewModel.steps.accept(PMSStep.presentTabbar)
    }
    
    public func success() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.input.viewDidLoad.accept(())
        }
    }
}

extension MypageViewController: StudentListDelegate {
    public func changeStudent(student: UsersStudent) {
        let lastUser = UDManager.shared.student
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if lastUser != UDManager.shared.student {
                AnalyticsManager.click_changeStudent.log()
                self.studentListView.viewModel.input.viewDidLoad.accept(())
                self.viewModel.input.viewDidLoad.accept(())
            }
        }
    }
    
    public func addStudentTapped() {
        AnalyticsManager.click_addStudent.log()
        self.blackBackground.isHidden = false
        self.addStudentView.view.isHidden = false
    }
    
    public func delete(student: UsersStudent) {
        let lastUser = UDManager.shared.student
        self.viewModel.steps.accept(PMSStep.deleteStudent(name: String(student.number) + " " + student.name, handler: { _ in
            if student.number == UDManager.shared.studentNumber {
                UDManager.shared.student = nil
            }
            AnalyticsManager.click_deleteStudent.log()
            self.viewModel.input.deleteStudent.accept(student.number)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.studentListView.viewModel.input.viewDidLoad.accept(())
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if lastUser != UDManager.shared.student {
                        self.viewModel.input.viewDidLoad.accept(())
                    }
                }
            }
        }))
    }
}

extension MypageViewController: AddStudentDelegate {
    public func dismissAddStudent() {
        self.addStudentView.view.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.studentListView.viewModel.input.viewDidLoad.accept(())
            self.viewModel.input.viewDidLoad.accept(())
        }
    }
}
