//
//  DeveloperViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class DeveloperViewModel: Stepper {
    let steps = PublishRelay<Step>()
    private let repository: IntroduceRepository
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let noInternet = PublishRelay<Void>()
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let developerList = PublishRelay<[Developer]>()
    }
    
    let input = Input()
    let output = Output()
    
    init(repository: IntroduceRepository) {
        self.repository = repository
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest { _ in
                repository.getDeveloper()
                    .asObservable()
                    .trackActivity(activityIndicator)
            }
            .bind(to: output.developerList)
            .disposed(by: disposeBag)
        
        input.noInternet
            .subscribe(onNext: { _ in
                    self.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
                
            })
            .disposed(by: disposeBag)
    }
}
