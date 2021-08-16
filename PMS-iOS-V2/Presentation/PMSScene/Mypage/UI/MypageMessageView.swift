//
//  MypageMessageView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/30.
//

import UIKit

final public class MypageMessageView: UIView {
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor.black
    }
    
    public convenience init(title: LocalizedString, label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
        self.titleLabel.text = title.localized
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        
        self.backgroundColor = .lightGray.lighter
        self.layer.cornerRadius = 20
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = Colors.gray.color.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(UIFrame.width - 70)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
