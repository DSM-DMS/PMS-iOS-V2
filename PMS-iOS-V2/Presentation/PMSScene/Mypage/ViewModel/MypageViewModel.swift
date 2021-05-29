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
        let outingListButtonTapped = PublishRelay<Void>()
        let chanegePasswordButtonTapped = PublishRelay<Void>()
        let logoutButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: MypageRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.outingListButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.outingListIsRequired)
            }.disposed(by: disposeBag)
        
        input.chanegePasswordButtonTapped
            .subscribe { _ in
                self.steps.accept(PMSStep.changePasswordIsRequired)
            }.disposed(by: disposeBag)
        
        input.logoutButtonTapped
            .subscribe { _ in
//                self.steps.accept(PMSStep.developerIsRequired)
            }.disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
}
