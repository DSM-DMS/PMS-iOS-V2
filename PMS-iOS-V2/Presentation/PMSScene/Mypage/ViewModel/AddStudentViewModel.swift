//
//  AddStudentViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import RxSwift
import RxCocoa
import RxFlow

class AddStudentViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let repository: MypageRepository
    private var disposeBag = DisposeBag()
    
    struct Input {
        let noInternet = PublishRelay<Void>()
        let otpString = BehaviorRelay<String>(value: "")
//        let isOtpEnded = PublishRelay<Bool>()
        let addButtonTapped = PublishRelay<Void>()
        let cancelButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let addButtonIsEnable = BehaviorRelay<Bool>(value: false)
        let isSucceed = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: MypageRepository) {
        self.repository = repository
        
        input.noInternet
            .subscribe(onNext: { _ in
                self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                
            })
            .disposed(by: disposeBag)
        
        input.otpString
            .map { if $0.count == 6 { return true } else { return false } }
            .bind(to: output.addButtonIsEnable)
            .disposed(by: disposeBag)
        
        input.addButtonTapped
            .asObservable()
            .flatMap {
                repository.addStudent(number: Int(self.input.otpString.value)!)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .bind(to: output.isSucceed)
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
