//
//  TabbarFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import UIKit
import RxFlow

class TabbarFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PMSStep else { return .none }

        switch step {
        case .tabBarIsRequired:
            return navigateToTabBar()
        default:
            return .none
        }
    }

    private func navigateToTabBar() -> FlowContributors {

        let calendarFlow = CalendarFlow()
        let mealFlow = MealFlow()
        let noticeFlow = NoticeFlow()
        let introduceFlow = IntroduceFlow()
        let mypageFlow = MypageFlow()

        Flows.use(calendarFlow, mealFlow, noticeFlow, introduceFlow, mypageFlow, when: .created) { [unowned self] (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController, root4: UINavigationController, root5: UINavigationController) in
            root1.tabBarItem = UITabBarItem(title: "Beer List", image: UIImage(named: "1.circle"), tag: 0)
            root2.tabBarItem = UITabBarItem(title: "Search ID", image: UIImage(named: "2.circle"), tag: 1)
            root3.tabBarItem = UITabBarItem(title: "Random", image: UIImage(named: "3.circle"), tag: 2)
            root4.tabBarItem = UITabBarItem(title: "Random", image: UIImage(named: "3.circle"), tag: 2)
            root5.tabBarItem = UITabBarItem(title: "Random", image: UIImage(named: "3.circle"), tag: 2)

            self.rootViewController.setViewControllers([root1, root2, root3, root4, root5], animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: calendarFlow,
                                                        withNextStepper: OneStepper(withSingleStep: PMSStep.calendarIsRequired)),
                                            .contribute(withNextPresentable: mealFlow,
                                                        withNextStepper: OneStepper(withSingleStep: PMSStep.mealIsRequired)),
                                            .contribute(withNextPresentable: noticeFlow,
                                                        withNextStepper: OneStepper(withSingleStep: PMSStep.noticeIsRequired)),
                                            .contribute(withNextPresentable: introduceFlow,
                                                        withNextStepper: OneStepper(withSingleStep: PMSStep.introduceIsRequired)),
                                            .contribute(withNextPresentable: mypageFlow,
                                                        withNextStepper: OneStepper(withSingleStep: PMSStep.mypageIsRequired))])
    }
}
