//
//  MentionButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
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
        self.setAccessibility(.previousPageButton)
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
        self.setAccessibility(.nextPageButton)
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

final public class MentionButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.mention.image, for: .normal)
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

final public class EnterButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.enter.image, for: .normal)
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

final public class ClipButton: UIButton {
    public convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.clip.image, for: .normal)
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

final public class DownloadImage: UIImageView {
    internal override init(image: UIImage? = Asset.download.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}
