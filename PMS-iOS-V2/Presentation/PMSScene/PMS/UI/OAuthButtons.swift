//
//  OAuthButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/20.
//

import UIKit

final public class FacebookButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.facebook.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}

final public class NaverButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.naver.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}

final public class KakaotalkButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.kakaoTalk.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 70, height: 70)
    }
}

final public class AppleButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.apple.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 65, height: 65)
    }
}

final public class EmptyView: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
