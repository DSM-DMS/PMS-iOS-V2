//
//  MypageFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit

class MypageFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PMSStep else { return .none }

        switch step {
        case .mypageIsRequired:
            return navigateToMypageScreen()
        case .changePasswordIsRequired:
            return navigateToChangePasswordScreen()
        case .scoreListIsRequired:
            return navigateToScoreListScreen()
        case .outingListIsRequired:
            return navigateToOutingListScreen()
        case .modalPMSIsRequired:
            return modalPMSScreen()
        case .alert(let string):
            return alert(string: string)
        default:
            return .none
        }
    }

    private func navigateToMypageScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(MypageViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToChangePasswordScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(ChangePasswordViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToScoreListScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(ScoreListViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToOutingListScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(OutingListViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func modalPMSScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(PMSViewController.self)!
        self.rootViewController.present(vc, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string)
        return .none
    }
}
