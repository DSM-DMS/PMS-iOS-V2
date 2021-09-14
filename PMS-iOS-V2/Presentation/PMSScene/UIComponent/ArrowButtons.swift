//
//  CalendarButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/23.
//

import UIKit

final public class LeftArrowButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.leftArrow.image, for: .normal)
        self.setAccessibility(.leftArrowButton)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
        self.tintColor = Colors.black.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 15, height: 15)
    }

}

final public class RightArrowButton: UIButton {
    convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.rightArrow.image, for: .normal)
        self.setAccessibility(.rightArrowButton)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
        self.tintColor = Colors.black.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 15, height: 15)
    }

}
