//
//  MealStep.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit
import Then

class MealFlow: Flow {
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
        case .mealIsRequired:
            return navigateToMealScreen()
        case .mealPictureIsRequired(let date):
            return navigateToMealPictureScreen(date: date)
        case .alert(let string, let access):
            return alert(string: string, access: access)
        default:
            return .none
        }
    }

    private func navigateToMealScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(MealViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToMealPictureScreen(date: String) -> FlowContributors {
        let vc = MealViewController(viewModel: AppDelegate.container.resolve(MealViewModel.self)!)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String, access: AccessibilityString) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string, access: access)
        return .none
    }
}
