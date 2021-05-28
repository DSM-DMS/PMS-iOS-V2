//
//  ClubCollectionCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/26.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ClubCollectionCell: UICollectionViewCell {
    
    private let background = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private let clubImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    private let clubLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    func setupView(model: Club) {
        self.clubLabel.text = model.name
        
        self.clubImage.kf.setImage(with: (URL(string: model.imageUrl)))
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([background, clubImage, clubLabel])
        background.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIFrame.width / 2 - 50)
            $0.height.equalTo(UIFrame.width / 2 - 15)
        }
        
        clubImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(90)
        }
        
        clubLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(clubImage.snp_bottomMargin).offset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(UIFrame.width / 2 - 30)
        }
    }
}
