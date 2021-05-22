//
//  Alert.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import Then

extension UIViewController {
    func showErrorAlert(with message: String, access: AccessibilityString) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil,
                                          message: message,
                                          preferredStyle: .alert)
            alert.accessibilityLabel = access.localized
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showSuccessLottie(label: LocalizedString) {
        DispatchQueue.main.async {
            let lottieView = SuccessLottieView(text: label)
            self.view.addSubview(lottieView)
            lottieView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.3, animations: {lottieView.alpha = 0.0},
                                           completion: {(_: Bool) in
                                            lottieView.removeFromSuperview()
                                           })
            }
        }
    }
}
