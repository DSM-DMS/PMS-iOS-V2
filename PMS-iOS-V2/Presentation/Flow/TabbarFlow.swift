//
//  TabbarFlow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import Foundation
import UIKit
import RxFlow

final public class TabbarFlow: Flow {
    public var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController().then {
        $0.tabBar.barTintColor = Colors.white.color
    }

    public init() {}

    public func navigate(to step: Step) -> FlowContributors {
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

        Flows.use(calendarFlow, mealFlow, noticeFlow, introduceFlow, mypageFlow, when: .created) { [unowned self]
            (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController, root4: UINavigationController, root5: UINavigationController) in
            root1.tabBarItem = UITabBarItem(title: .calendar, image: Asset.calendar.image, tag: 0)
            root2.tabBarItem = UITabBarItem(title: .meal, image: Asset.meal.image, tag: 1)
            root3.tabBarItem = UITabBarItem(title: .notice, image: Asset.notice.image, tag: 2)
            root4.tabBarItem = UITabBarItem(title: .introduce, image: Asset.introduce.image, tag: 3)
            root5.tabBarItem = UITabBarItem(title: .mypage, image: Asset.mypage.image, tag: 4)

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
