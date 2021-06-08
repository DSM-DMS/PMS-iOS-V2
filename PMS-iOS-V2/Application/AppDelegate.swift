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
import FirebaseMessaging
import UserNotifications
import Moya

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()
    static var window: UIWindow?
    static let container = Container()
    let stepper = AppStepper()
    
    let provider = MoyaProvider<AuthApi>()
    
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
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        AnalyticsManager.setUserID()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.alert, .sound]])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        if let token = fcmToken {
            pushToken(token: token)
            let dataDict:[String: String] = ["token": token]
            NotificationCenter.default.post(name: Notification.Name("fcmToken"), object: nil, userInfo: dataDict)
        }
    }
    
    func pushToken(token: String) {
        if token != UserDefaults.standard.string(forKey: "fcmToken") {
            provider.request(.notification(token: token)) { result in
                switch result {
                case .success:
                    Log.info("Success")
                    UserDefaults.standard.setValue(token, forKey: "fcmToken")
                case let .failure(error):
                    Log.info(error)
                }
            }
        }
        
    }
}

extension AppDelegate {
    func PMSIsRequired() {
        stepper.steps.accept(PMSStep.PMSIsRequired)
    }
}
