//
//  MealCollectionViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class MealCollectionViewCell: UITableViewCell {
    private let timeLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textColor = .white
    }
    
    private let mealLabel = UILabel().then {
        $0.textColor = Colors.black.color
    }
    
    private let blueBackground = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        $0.backgroundColor = Colors.blue.color
    }
    
    private let whiteBackground = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        $0.backgroundColor = Colors.white.color
    }
    
    private let mealCellBackground = UIStackView().then {
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    func setupView(model: MealCell) {
        DispatchQueue.main.async {
            self.timeLabel.setText(model.time)
            self.mealLabel.text = model.meal.joined()
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubview(mealCellBackground)
        mealCellBackground.addArrangeSubviews([blueBackground, whiteBackground])
        mealCellBackground.addSubViews([timeLabel, mealLabel])
        mealCellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 70)
        }
        timeLabel.snp.makeConstraints {
            $0.center.equalTo(blueBackground)
        }
        mealLabel.snp.makeConstraints {
            $0.centerX.equalTo(whiteBackground)
            $0.top.equalTo(whiteBackground.snp_bottomMargin).offset(20)
        }
        
    }
}

class FlipImage: UIImageView {
    override init(image: UIImage? = Asset.mealFlip.image) {
        super.init(image: image)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
}
