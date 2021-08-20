//
//  PageButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/24.
//

import UIKit

final public class PreviousPageButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.blueLeftArrow.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 13, height: 13)
    }

}

final public class NextPageButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.blueRightArrow.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 13, height: 13)
    }

}
