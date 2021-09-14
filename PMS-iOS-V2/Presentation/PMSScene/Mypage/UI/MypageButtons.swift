//
//  MypageButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit

final public class WhitePencilButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.whitePencil.image, for: .normal)
        self.setAccessibility(.modifyNickname)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }

}

final public class BottomArrowButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.bottomArrow.image, for: .normal)
        self.setAccessibility(.viewStudents)
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

final public class CirclePlusButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.circlePlus.image, for: .normal)
        self.setAccessibility(.addStudent)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 25, height: 25)
    }

}
