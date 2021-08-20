//
//  MypageViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class MypageViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    private let repository: MypageRepository
    private let disposeBag = DisposeBag()
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let backgroundTapped = PublishRelay<Void>()
        let studentListButtonTapped = PublishRelay<Void>()
        let changeNicknameButtonTapped = PublishRelay<Void>()
        let pointListButtonTapped = PublishRelay<Void>()
        let outingListButtonTapped = PublishRelay<Void>()
        let chanegePasswordButtonTapped = PublishRelay<Void>()
        let logoutButtonTapped = PublishRelay<Void>()
        let deleteStudent = PublishRelay<Int>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isNoLogin = BehaviorRelay<Bool>(value: false)
        let user = PublishRelay<User>()
        let nickName = PublishRelay<String>()
        let isStudent = PublishRelay<Bool>()
        let studentName = PublishRelay<String>()
        let studentList = BehaviorRelay<[UsersStudent]>(value: .init())
        let studentStatus = PublishRelay<Student>()
    }
    
    public let input = Input()
    public let output = Output()
    
    public init(repository: MypageRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest { _ in
                repository.getUser()
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
            }
            .bind(to: output.user)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map { _ in
                let user = StorageManager.shared.readUser()!
                if user.email == Bundle.main.infoDictionary!["Auth Email"] as! String {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: output.isNoLogin)
            .disposed(by: disposeBag)
        
        output.user
            .map { $0.name }
            .bind(to: output.nickName)
            .disposed(by: disposeBag)
        
        output.user
            .map { $0.students }
            .bind(to: output.studentList)
            .disposed(by: disposeBag)
        
        output.user
            .map { !$0.students.isEmpty }
            .bind(to: output.isStudent)
            .disposed(by: disposeBag)
        
        output.isStudent
            .filter { $0 == true }
            .map { _ in UDManager.shared.student! }
            .bind(to: output.studentName)
            .disposed(by: disposeBag)
        
        output.isStudent
            .filter { $0 == true }
            .flatMapLatest { _ in
                repository.getStudent(number: UDManager.shared.studentNumber!)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
            }
            .bind(to: output.studentStatus)
            .disposed(by: disposeBag)
        
        input.backgroundTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.presentTabbar)
            }.disposed(by: disposeBag)
        
        input.studentListButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.dismissTabbar)
            }.disposed(by: disposeBag)
        
        input.changeNicknameButtonTapped
            .subscribe { _ in
                AnalyticsManager.view_changeNickname.log()
                self.steps.accept(PMSStep.dismissTabbar)
            }.disposed(by: disposeBag)
        
        input.pointListButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.pointListIsRequired(number: UDManager.shared.studentNumber!))
            }.disposed(by: disposeBag)
        
        input.outingListButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.outingListIsRequired(number: UDManager.shared.studentNumber!))
            }.disposed(by: disposeBag)
        
        input.chanegePasswordButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.changePasswordIsRequired)
            }.disposed(by: disposeBag)
        
        input.logoutButtonTapped
            .subscribe { _ in
                AnalyticsManager.view_logout.log()
                self.steps.accept(PMSStep.logout)
            }.disposed(by: disposeBag)
        
        input.deleteStudent
            .flatMapLatest {
                repository.deleteStudent(number: $0)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
            }.subscribe { _ in }
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
        
    }
    
    private func mapError(error: Int) -> String {
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else if error == 403 {
            return LocalizedString.notMatchCurrentPasswordErrorMsg.localized
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private  func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 403 {
            return .notMatchCurrentPasswordErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
