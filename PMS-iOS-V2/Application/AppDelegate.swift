//
//  AppDelegate.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/16.
//

import UIKit
import Swinject
import RxFlow
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()
    var window: UIWindow?
    static let container = Container()
    static let stepper = AppStepper()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.container.registerDependencies()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow()
        
        self.coordinator.coordinate(flow: appFlow, with: AppDelegate.stepper)
        
        Flows.use(appFlow, when: .created) { root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        
        Flows.use(appFlow, when: .ready) { root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        return true
    }

}
