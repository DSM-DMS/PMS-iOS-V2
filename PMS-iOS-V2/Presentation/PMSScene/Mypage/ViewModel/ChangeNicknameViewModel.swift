//
//  ChangeNicknameViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import RxSwift
import RxCocoa
import RxFlow

class ChangeNicknameViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let repository: MypageRepository
    private var disposeBag = DisposeBag()
    
    struct Input {
        let noInternet = PublishRelay<Void>()
        let nicknameText = BehaviorRelay<String>(value: "")
        let changeButtonTapped = PublishRelay<Void>()
        let cancelButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isNicknameTyping = PublishRelay<Bool>()
        let changeButtonIsEnable = BehaviorRelay<Bool>(value: false)
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
        
        input.nicknameText
            .map { if $0.count > 0 { return true } else { return false }}
            .bind(to: output.isNicknameTyping)
            .disposed(by: disposeBag)
        
        input.nicknameText
            .map { if $0.count > 0 { return true } else { return false } }
            .bind(to: output.changeButtonIsEnable)
            .disposed(by: disposeBag)
        
        input.changeButtonTapped
            .asObservable()
            .flatMap {
                repository.changeNickname(name: self.input.nicknameText.value)
                    .do(onError: { error in
                        let error = error as! NetworkError
                        self.steps.accept(PMSStep.alert(self.mapError(error: error.rawValue), self.mapError(error: error.rawValue)))
                    })
                    .catchErrorJustReturn(false)
            }
            .subscribe { _ in }
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
