//
//  MypageFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit
import Then

class MypageFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController().then {
        $0.isNavigationBarHidden = true
    }

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
        case .alert(let string, let access):
            return alert(string: string, access: access)
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
    
    private func alert(string: String, access: AccessibilityString) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string, access: access)
        return .none
    }
}
