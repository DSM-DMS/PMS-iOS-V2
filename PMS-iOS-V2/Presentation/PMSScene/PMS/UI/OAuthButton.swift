//
//  OAuthButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/20.
//

import UIKit

class FacebookButton: UIButton {
    convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.facebook.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}

class NaverButton: UIButton {
    convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.naver.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}

class KakaotalkButton: UIButton {
    convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.kakaoTalk.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}

class AppleButton: UIButton {
    convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.apple.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 65, height: 65)
    }
}

class EmptyView: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
