//
//  PMSView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PMSImage: UIImageView {
    override init(image: UIImage? = Asset.pms.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NoLoginButton: UIButton {
    convenience init(title: LocalizedString) {
        self.init()
        self.setTitle(title)
        self.setAccessibility(.noLoginButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(Colors.blue.color, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PersonImage: UIImageView {
    override init(image: UIImage? = Asset.person.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 18, height: 18)
    }
}

class LockImage: UIImageView {
    override init(image: UIImage? = Asset.lock.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}

class EyeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.eye.image, for: .normal)
        self.setAccessibility(.showPasswordButton)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 25, height: 15)
    }
}

class BlackPencilImage: UIImageView {
    override init(image: UIImage? = Asset.blackPencil.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
        self.tintColor = Colors.black.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}

class CircleCheckImage: UIImageView {
    override init(image: UIImage? = Asset.circleCheck.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}

class CheckImage: UIImageView {
    override init(image: UIImage? = Asset.check.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
        self.tintColor = Colors.red.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}

class PMSTextField: UITextField {
    convenience init(title: LocalizedString) {
        self.init()
        self.setPlaceholder(title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
