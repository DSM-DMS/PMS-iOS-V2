//
//  MypageViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class MypageViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let repository: MypageRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let getStudent = PublishRelay<Void>()
        let outingListButtonTapped = PublishRelay<Void>()
        let chanegePasswordButtonTapped = PublishRelay<Void>()
        let logoutButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = PublishRelay<Bool>()
        let user = PublishRelay<User>()
        let nickName = PublishRelay<String>()
        let isStudent = PublishRelay<Bool>()
        let studentStatus = PublishRelay<Student>()
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: MypageRepository) {
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
        
        output.user
            .map { $0.name }
            .bind(to: output.nickName)
            .disposed(by: disposeBag)
        
        output.user
            .map { !$0.students.isEmpty }
            .bind(to: output.isStudent)
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
                self.steps.accept(PMSStep.logout)
            }.disposed(by: disposeBag)
        
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
