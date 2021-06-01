//
//  StudentListViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import RxSwift
import RxCocoa
import RxFlow

class StudentListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let repository: MypageRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let noInternet = PublishRelay<Void>()
        let deleteButtonTapped = PublishRelay<UsersStudent>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let studentList = PublishRelay<[UsersStudent]>()
        let change = PublishRelay<Void>()
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
            .map { $0.students }
            .bind(to: output.studentList)
            .disposed(by: disposeBag)
        
        input.noInternet
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .filter { $0.number == UDManager.shared.studentNumber! }
            .map { _ in }
            .bind(to: output.change)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
    
    private func mapError(error: Int) -> String {
        if error == 1 {
            return LocalizedString.noInternetErrorMsg.localized
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return "내부 로직 오류"
        } else {
            return LocalizedString.unknownErrorMsg.localized
        }
    }
    
    private func mapError(error: Int) -> AccessibilityString {
        if error == 1 {
            return .noInternetErrorMsg
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return .unknownErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
