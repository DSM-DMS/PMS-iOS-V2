//
//  AddStudentViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import RxSwift
import RxCocoa
import RxFlow

final public class AddStudentViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: MypageRepository
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let noInternet = PublishRelay<Void>()
        let otpString = BehaviorRelay<String>(value: "")
        let addButtonTapped = PublishRelay<Void>()
        let cancelButtonTapped = PublishRelay<Void>()
    }
    
    public struct Output {
        let addButtonIsEnable = BehaviorRelay<Bool>(value: false)
        let isSucceed = PublishRelay<Bool>()
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        input.noInternet
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                
            })
            .disposed(by: disposeBag)
        
        input.otpString
            .map { if $0.count == 6 { return true } else { return false } }
            .bind(to: output.addButtonIsEnable)
            .disposed(by: disposeBag)
        
        input.addButtonTapped
            .asObservable()
            .flatMap { [weak self] _ -> Single<Bool> in
                guard let self = self else { return Single.just(false) }
                
                return self.repository.addStudent(number: Int(self.input.otpString.value)!)
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
        } else if error == 404 {
            return LocalizedString.notFoundUserErrorMsg.localized
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
        } else if error == 404 {
            return .notFoundUserErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
