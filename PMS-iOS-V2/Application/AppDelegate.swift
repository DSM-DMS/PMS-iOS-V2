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
import FirebaseCrashlytics
import Moya
import FBSDKCoreKit
import NaverThirdPartyLogin
import KakaoOpenSDK

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let disposeBag = DisposeBag()
    private var coordinator = FlowCoordinator()
    static var window: UIWindow?
    static let container = Container()
    private let stepper = AppStepper()
    
    private let provider = MoyaProvider<AuthApi>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - RxFlow
        
        AppDelegate.container.registerDependencies()
        
        AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
//        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
//            print("will navigate to flow=\(flow) and step=\(step)")
//        }).disposed(by: self.disposeBag)
//
//        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
//            print("did navigate to flow=\(flow) and step=\(step)")
//        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow(window: AppDelegate.window!)
        
        self.coordinator.coordinate(flow: appFlow, with: stepper)
        
        // MARK: - Firebase
        
        FirebaseApp.configure()
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        application.registerForRemoteNotifications()
        AnalyticsManager.setUserID()

        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        // MARK: - OAuth
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
                launchOptions
        )
        
        // MARK: - Naver
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 앱으로 인증하는 방식 활성화
        instance?.isNaverAppOauthEnable = true
        
        // SafariViewController에서 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true
        
        // 인증 화면을 아이폰의 세로모드에서만 적용
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.setOnlyPortraitSupportInIphone(true)
        instance?.serviceUrlScheme = kServiceAppUrlScheme // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = kConsumerKey // 상수 - client id
        instance?.consumerSecret = kConsumerSecret // pw
        instance?.appName = kServiceAppName // app name
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
        
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            options: options
        )
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
        KOSession.handleDidBecomeActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        KOSession.handleDidEnterBackground()
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
            if StorageManager.shared.readUser() != nil {
                pushToken(token: token)
            }
            let dataDict: [String: String] = ["token": token]
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
