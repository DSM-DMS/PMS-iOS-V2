//
//  IntroduceCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
//

import UIKit

class IntroduceCell: UIButton {
    
    private let _titleLabel = UILabel()
    private let descLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.textColor = Colors.gray.color
    }
    
    convenience init(title: AccessibilityString, desc: AccessibilityString) {
        self.init()
//        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.blueLeftArrow.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 13, height: 13)
    }

}
