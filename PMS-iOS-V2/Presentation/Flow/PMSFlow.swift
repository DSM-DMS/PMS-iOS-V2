//
//  PMSFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit

class PMSFlow: Flow {
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
        case .PMSIsRequired:
            return navigateToPMSScreen()
        case .loginIsRequired:
            return navigateToLoginScreen()
        case .registerIsRequired:
            return navigateToRegisterScreen()
        case .alert(let string, let access):
            return alert(string: string, access: access)
        case .success(let string):
            return successLottie(string: string)
        case .tabBarIsRequired:
            return navigateToMainScreen()
        default:
            return .none
        }
    }

    private func navigateToPMSScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(PMSViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToLoginScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(LoginViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToRegisterScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(RegisterViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToMainScreen() -> FlowContributors {
        let tabbarFlow = TabbarFlow()

        Flows.use(tabbarFlow, when: .ready) { [unowned self] root in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.rootViewController.viewControllers.removeAll()
                self.rootViewController.pushViewController(root, animated: false)
            }
        }

        return .one(flowContributor: .contribute(withNextPresentable: tabbarFlow,
                                                 withNextStepper: OneStepper(withSingleStep: PMSStep.tabBarIsRequired)))
    }
    
    private func alert(string: String, access: AccessibilityString) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string, access: access)
        return .none
    }
    
    private func successLottie(string: LocalizedString) -> FlowContributors {
        self.rootViewController.showSuccessLottie(label: string)
        return .none
    }
}
