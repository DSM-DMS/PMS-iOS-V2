//
//  DeveloperCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/27.
//

import UIKit
import SnapKit
import Then

final public class DeveloperCollectionCell: UICollectionViewCell {
    private let background = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = Colors.gray.color.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private let personImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 45
        $0.layer.masksToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textColor = UIColor.black
    }
    
    private let fieldLabel = UILabel().then {
        $0.textColor = .gray
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: Developer) {
        self.nameLabel.text = model.name
        self.fieldLabel.text = model.field
        self.personImage.image = model.image
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([background, personImage, nameLabel, fieldLabel])
        background.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIFrame.width / 2 - 50)
            $0.height.equalTo(UIFrame.width / 2 - 15)
        }
        
        personImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.height.equalTo(90)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(personImage.snp_bottomMargin).offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(UIFrame.width / 2 - 30)
        }
        
        fieldLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp_bottomMargin).offset(20)
            $0.height.equalTo(15)
        }
    }
}
