//
//  AppFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
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
            self.rootViewController = root as! UINavigationController
        }

        return .one(flowContributor: .contribute(withNextPresentable: pmsFlow,
                                                 withNextStepper: OneStepper(withSingleStep: PMSStep.PMSIsRequired)))
    }

    private func navigationToTabbarScreen() -> FlowContributors {
        let dashboardFlow = TabbarFlow()

        Flows.use(dashboardFlow, when: .created) { [unowned self] root in
//            self.rootViewController.isNavigationBarHidden = true
            self.rootViewController.pushViewController(root, animated: false)
        }

        return .one(flowContributor: .contribute(withNextPresentable: dashboardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: PMSStep.tabBarIsRequired)))
    }
    
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    var initialStep: Step {
        return PMSStep.PMSIsRequired
    }
    
    var userIsSignedIn: Observable<Bool> {
        return .just(StorageManager.shared.readUser() != nil)
    }
    
    func readyToEmitSteps() {
        userIsSignedIn
            .map { $0 ? PMSStep.tabBarIsRequired : PMSStep.PMSIsRequired }
            .bind(to: steps)
            .disposed(by: self.disposeBag)
    }
}
