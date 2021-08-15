//
//  NoticeFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxFlow
import UIKit

final public class NoticeFlow: Flow {
    public var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    public init() {}

    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PMSStep else { return .none }

        switch step {
        case .noticeIsRequired:
            return navigateToNoticeScreen()
        case .detailNoticeIsRequired(let id, let title):
            return navigateToDetailNoticeScreen(id: id, title: title)
        case .alert(let string, let access):
            return alert(string: string, access: access)
        default:
            return .none
        }
    }

    private func navigateToNoticeScreen() -> FlowContributors {
        let vc = AppDelegate.container.resolve(NoticeViewController.self)!
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToDetailNoticeScreen(id: Int, title: String) -> FlowContributors {
        let repository = AppDelegate.container.resolve(NoticeRepository.self)!
        let vc = NoticeDetailViewController(viewModel: NoticeDetailViewModel(id: id, title: title, repository: repository))
        vc.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func alert(string: String, access: AccessibilityString) -> FlowContributors {
        self.rootViewController.showErrorAlert(with: string, access: access)
        return .none
    }
}
