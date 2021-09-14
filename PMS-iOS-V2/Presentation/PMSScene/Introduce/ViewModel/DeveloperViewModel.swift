//
//  DeveloperViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

final public class DeveloperViewModel: Stepper {
    public let steps = PublishRelay<Step>()
    @Inject private var repository: IntroduceRepository
    private let disposeBag = DisposeBag()
    
    public struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let noInternet = PublishRelay<Void>()
    }
    
    public struct Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let developerList = PublishRelay<[Developer]>()
    }
    
    public let input = Input()
    public let output = Output()
    
    public init() {
        let activityIndicator = ActivityIndicator()
        
        input.viewDidLoad
            .asObservable()
            .flatMapLatest { [weak self] _ -> Observable<[Developer]> in
                guard let self = self else { return Observable.just([Developer]()) }
                
                return self.repository.getDeveloper()
                    .asObservable()
                    .trackActivity(activityIndicator)
            }
            .bind(to: output.developerList)
            .disposed(by: disposeBag)
        
        input.noInternet
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(PMSStep.alert(LocalizedString.noInternetErrorMsg.localized, .noInternetErrorMsg))
            })
            .disposed(by: disposeBag)
    }
}
