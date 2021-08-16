//
//  ChangeNicknameViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import RxSwift
import RxCocoa
import RxFlow

final public class ChangeNicknameViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    private let repository: MypageRepository
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let noInternet = PublishRelay<Void>()
        let nicknameText = BehaviorRelay<String>(value: "")
        let changeButtonTapped = PublishRelay<Void>()
        let cancelButtonTapped = PublishRelay<Void>()
    }
    
    public struct Output {
        let isNicknameTyping = PublishRelay<Bool>()
        let changeButtonIsEnable = BehaviorRelay<Bool>(value: false)
    }
    
    public let input = Input()
    public let output = Output()
    
    public init(repository: MypageRepository) {
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
            .map { AnalyticsManager.click_changeNickname.log() }
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
        } else if error == 401 {
            Log.info("Token Refresh wasn't complete")
            return "내부 로직 오류"
        } else if error == 403 {
            return LocalizedString.notMatchStudentErrorMsg.localized
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
        } else if error == 403 {
            return .notMatchStudentErrorMsg
        } else {
            return .unknownErrorMsg
        }
    }
}
