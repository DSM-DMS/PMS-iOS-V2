//
//  IntroduceFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit

class IntroduceFlow: Flow {
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
        case .introduceIsRequired:
            return navigateToIntroduceScreen()
        case .clubIsRequired:
            return navigateToClubScreen()
        case .detailClubIsRequired(let name):
            return navigateToDetailClubScreen(name: name)
        case .companyIsRequired:
            return navigateToCompanyScreen()
        case .detailCompanyIsRequired(let name):
            return navigateToDetailCompanyScreen(name: name)
        case .developerIsRequired:
            return navigateToDeveloperScreen()
        case .alert(let string):
            return alert(string: string)
        default:
            return .none
        }
    }

    private func navigateToIntroduceScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(IntroduceViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToClubScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(ClubViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToDetailClubScreen(name: String) -> FlowContributors {
        let vc = ClubDetailViewController(viewModel: AppDelegate.container.resolve(ClubViewModel.self)!, name: name)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToCompanyScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(CompanyViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToDetailCompanyScreen(name: String) -> FlowContributors {
        let vc = CompanyDetailViewController(viewModel: AppDelegate.container.resolve(CompanyViewModel.self)!, name: name)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToDeveloperScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(DeveloperViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string)
        return .none
    }
}
