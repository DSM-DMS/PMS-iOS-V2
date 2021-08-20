//
//  MypageButton.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/28.
//

import UIKit

final public class MypageRow: UIButton {
    private let _titleLabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let arrowImage = UIImageView().then {
        $0.image = Asset.rightArrow.image
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor.black
    }
    
    public convenience init(title: LocalizedString, label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
        self._titleLabel.text = title.localized
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([_titleLabel, arrowImage])
        
        self.backgroundColor = Colors.lightGray.color
        self.layer.cornerRadius = 15
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = Colors.gray.color.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(UIFrame.width - 70)
        }
        
        _titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        arrowImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
