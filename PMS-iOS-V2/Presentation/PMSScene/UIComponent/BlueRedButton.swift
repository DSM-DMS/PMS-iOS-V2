//
//  BlueRedButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/20.
//

import UIKit

final class BlueButton: UIButton {
    convenience init(title: LocalizedString, label: AccessibilityString) {
        self.init()
        self.setTitle(title)
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.blue.color
        self.layer.cornerRadius = 5
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class RedButton: UIButton {
    
    convenience init(title: LocalizedString, label: AccessibilityString) {
        self.init()
        self.setTitle(title)
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.red.color
        self.layer.cornerRadius = 5
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
