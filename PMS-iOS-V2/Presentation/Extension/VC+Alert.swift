//
//  Alert.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import Then

public extension UIViewController {
    func showErrorAlert(with message: String, access: AccessibilityString) {
        AnalyticsManager.error.log(message: message)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .alert)
            alert.accessibilityLabel = access.localized
            alert.addAction(UIAlertAction(title: LocalizedString.confirm.localized,
                                          style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showSuccessLottie(label: LocalizedString) {
        AnalyticsManager.success.log(label: label.localized)
        DispatchQueue.main.async {
            let lottieView = SuccessLottieView(text: label)
            self.view.addSubview(lottieView)
            lottieView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIView.animate(withDuration: 0.3, animations: {lottieView.alpha = 0.0},
                                           completion: {(_: Bool) in
                                            lottieView.removeFromSuperview()
                                           })
            }
        }
    }
    
    func showLogoutAlert(handler: @escaping (UIAlertAction) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message: LocalizedString.logoutConfirmMsg.localized,
                                          preferredStyle: .alert)
            alert.accessibilityLabel = LocalizedString.logoutConfirmMsg.localized
            let cancel = UIAlertAction(title: LocalizedString.cancel.localized, style: .destructive, handler: nil)
            let logoutAction = UIAlertAction(title: LocalizedString.confirm.localized, style: .default, handler: handler)
            alert.addAction(cancel)
            alert.addAction(logoutAction)
            self.present(alert, animated: true)
        }
    }
    
    func showDeleteAlert(name: String, handler: @escaping (UIAlertAction) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message:
                                            name + "\n" +
                                            LocalizedString.deleteStudentMsg.localized,
                                          preferredStyle: .alert)
            alert.accessibilityLabel = LocalizedString.deleteStudentMsg.localized
            let cancel = UIAlertAction(title: LocalizedString.cancel.localized, style: .destructive, handler: nil)
            let logoutAction = UIAlertAction(title: LocalizedString.confirm.localized, style: .default, handler: handler)
            alert.addAction(cancel)
            alert.addAction(logoutAction)
            self.present(alert, animated: true)
        }
    }
}
