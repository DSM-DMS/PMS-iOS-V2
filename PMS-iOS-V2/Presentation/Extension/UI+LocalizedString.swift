//
//  UIButton+LocalizedString.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/20.
//

import UIKit

extension UIButton {
    public func setTitle(_ title: LocalizedString) {
        self.setTitle(title.localized, for: .normal)
    }
}

extension UIView {
    public func setAccessibility(_ label: AccessibilityString) {
        self.accessibilityLabel = label.localized
    }
}

extension UILabel {
    public func setText(_ text: LocalizedString) {
        self.text = text.localized
    }
}

extension UITextField {
    public func setPlaceholder(_ title: LocalizedString) {
        self.placeholder = title.localized
    }
}

extension UIViewController {
    public func setNavigationTitle(title: LocalizedString, accessibilityLabel: AccessibilityString, isLarge: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = isLarge
        self.navigationItem.title = title.localized
        self.navigationItem.accessibilityLabel = accessibilityLabel.localized
    }
}

extension UITabBarItem {
    public convenience init(title: LocalizedString, image: UIImage, tag: Int) {
        self.init(title: title.localized, image: image, tag: tag)
    }
}
