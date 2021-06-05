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
        case .pointListIsRequired(let number):
            return navigateToPointListScreen(number: number)
        case .outingListIsRequired(let number):
            return navigateToOutingListScreen(number: number)
        case .alert(let string, let access):
            return alert(string: string, access: access)
        case .success(let string):
            return successLottie(string: string)
        case .logout:
            return logoutAlert()
        case .deleteStudent(let name, let handler):
            return deleteStudentAlert(name: name, handler: handler)
        case .dismissTabbar:
            return dismissTabbar()
        case .presentTabbar:
            return presentTabbar()
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
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToPointListScreen(number: Int) -> FlowContributors {
        let repository = AppDelegate.container.resolve(PointListRepository.self)!
        let viewModel = PointListViewModel(repository: repository, number: number)
        let vc = PointListViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToOutingListScreen(number: Int) -> FlowContributors {
        let repository = AppDelegate.container.resolve(OutingListRepository.self)!
        let viewModel = OutingListViewModel(repository: repository, number: number)
        let vc = OutingListViewController(viewModel: viewModel)
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String, access: AccessibilityString) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string, access: access)
        return .none
    }
    
    private func deleteStudentAlert(name: String, handler: @escaping (UIAlertAction) -> Void) -> FlowContributors {
        self.rootViewController.showDeleteAlert(name: name, handler: handler)
        return .none
    }
    
    private func successLottie(string: LocalizedString) -> FlowContributors {
        self.rootViewController.showSuccessLottie(label: string)
        return .none
    }
    
    private func logoutAlert() -> FlowContributors {
        self.rootViewController.showLogoutAlert(handler: { _ in
            StorageManager.shared.deleteUser()
            (UIApplication.shared.delegate as? AppDelegate)?.PMSIsRequired()
        })
        return .none
        
    }
    
    private func presentTabbar() -> FlowContributors {
        self.rootViewController.tabBarController?.tabBar.isHidden = false
        return .none
    }
    
    private func dismissTabbar() -> FlowContributors {
        self.rootViewController.tabBarController?.tabBar.isHidden = true
        return .none
    }
    
}
