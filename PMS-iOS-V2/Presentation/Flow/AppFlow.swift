//
//  AppFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

final public class AppFlow: Flow {
    public var root: Presentable {
        return self.rootWindow
    }
    
    private let rootWindow: UIWindow
    
    public init(window: UIWindow) {
        self.rootWindow = window
    }

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PMSStep else { return .none }

        switch step {
        case .PMSIsRequired:
            return navigationToPMSScreen()
        case .tabBarIsRequired:
            return navigationToTabbarScreen()
        default:
            return .none
        }
    }
    
    private func navigationToPMSScreen() -> FlowContributors {
        let pmsFlow = PMSFlow()

        Flows.use(pmsFlow, when: .created) { [unowned self] root in
            self.rootWindow.rootViewController = root as! UINavigationController
            self.rootWindow.makeKeyAndVisible()
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: pmsFlow,
                                                 withNextStepper: OneStepper(withSingleStep: PMSStep.PMSIsRequired)))
    }

    private func navigationToTabbarScreen() -> FlowContributors {
        let dashboardFlow = TabbarFlow()

        Flows.use(dashboardFlow, when: .created) { [unowned self] root in
            let navigationController = UINavigationController(rootViewController: root).then {
                $0.isNavigationBarHidden = true
            }
            self.rootWindow.rootViewController = navigationController
            self.rootWindow.makeKeyAndVisible()
        }

        return .one(flowContributor: .contribute(withNextPresentable: dashboardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: PMSStep.tabBarIsRequired)))
    }
    
}

final public class AppStepper: Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public var initialStep: Step {
        return PMSStep.PMSIsRequired
    }
    
    private var userIsSignedIn: Observable<Bool> {
        return .just(StorageManager.shared.readUser() != nil)
    }
    
    public func readyToEmitSteps() {
        userIsSignedIn
            .map { $0 ? PMSStep.tabBarIsRequired : PMSStep.PMSIsRequired }
            .bind(to: steps)
            .disposed(by: self.disposeBag)
    }
}
