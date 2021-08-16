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

final public class PMSImage: UIImageView {
    internal override init(image: UIImage? = Asset.pms.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIFrame.width / 2, height: UIFrame.width / 2)
    }
}

final public class NoLoginButton: UIButton {
    public convenience init(title: LocalizedString) {
        self.init()
        self.setTitle(title)
        self.setAccessibility(.noLoginButton)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(Colors.blue.color, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final public class PersonImage: UIImageView {
    internal override init(image: UIImage? = Asset.person.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 18, height: 18)
    }
}

final public class LockImage: UIImageView {
    internal override init(image: UIImage? = Asset.lock.image) {
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

final public class EyeButton: UIButton {
    public override init(frame: CGRect) {
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
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 25, height: 15)
    }
}

final public class BlackPencilImage: UIImageView {
    internal override init(image: UIImage? = Asset.blackPencil.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
        self.tintColor = Colors.black.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}

final public class CircleCheckImage: UIImageView {
    internal override init(image: UIImage? = Asset.circleCheck.image) {
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

final public class CheckImage: UIImageView {
    internal override init(image: UIImage? = Asset.check.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
        self.tintColor = Colors.red.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 20, height: 20)
    }
}

final public class PMSTextField: UITextField {
    public convenience init(title: LocalizedString) {
        self.init()
        self.setPlaceholder(title)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
