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
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()
    static var window: UIWindow?
    static let container = Container()
    let stepper = AppStepper()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.container.registerDependencies()
        
        AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow(window: AppDelegate.window!)
        
        self.coordinator.coordinate(flow: appFlow, with: stepper)
        
        FirebaseApp.configure()
        AnalyticsManager.setUserID()
        
        return true
    }

}

extension AppDelegate {
    func PMSIsRequired() {
        stepper.steps.accept(PMSStep.PMSIsRequired)
    }
}
