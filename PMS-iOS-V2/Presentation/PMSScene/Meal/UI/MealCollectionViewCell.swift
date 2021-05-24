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
import RxCocoa
import RxSwift
import SkeletonView

class MealCollectionViewCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    
    private let timeLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .white
    }
    
    private let mealLabel = UILabel().then {
        $0.textColor = Colors.black.color
        $0.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.fitTextToBounds()
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 0
    }
    
    private let mealImage = UIImageView().then {
        $0.image = nil
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        $0.isHidden = true
        $0.isSkeletonable = true
        $0.backgroundColor = Colors.gray.color
    }
    
    private let noMealLabel = UILabel().then {
        $0.isHidden = true
        $0.text = LocalizedString.noMealPicturePlaceholder.localized
    }
    
    private let flipButton = FlipButton()
    
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
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    func setupView(model: MealCell) {
        DispatchQueue.main.async {
            self.timeLabel.setText(model.time)
            if model.meal.isEmpty {
                self.mealLabel.text = LocalizedString.noMealPlaceholder.localized
            } else {
                self.mealLabel.text = model.meal.joined(separator: "\n")
            }
            self.mealImage.image = nil
            
            if model.imageURL == "" {
                self.noMealLabel.isHidden = false
                self.mealImage.image = nil
            } else {
                self.noMealLabel.isHidden = true
                self.mealImage.kf.setImage(with: URL(string: model.imageURL), placeholder: nil, options: nil, progressBlock: { _, _ in
                    self.mealImage.showAnimatedGradientSkeleton()
                }, completionHandler: { _ in self.mealImage.stopSkeletonAnimation() })
            }
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([whiteBackground, blueBackground])
        blueBackground.addSubview(timeLabel)
        whiteBackground.addSubViews([mealLabel, mealImage, flipButton])
        mealImage.addSubview(noMealLabel)
        blueBackground.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(55)
            $0.bottom.equalTo(whiteBackground.snp_topMargin)
            $0.width.equalToSuperview()
        }
        whiteBackground.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(20)
        }
        mealLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(blueBackground.snp_bottomMargin).offset(40)
            $0.width.equalToSuperview()
        }
        mealImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.height.equalTo(UIFrame.height / 5)
            $0.width.equalToSuperview().offset(-20)
        }
        noMealLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(15)
        }
        flipButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(whiteBackground.snp_bottomMargin).offset(-40)
        }
        
        flipButton.rx.tap
            .subscribe { _ in
                if self.mealImage.isHidden {
                    self.mealLabel.isHidden = true

                    UIView.animate(withDuration: 0.3, animations: {
                                    self.mealImage.isHidden = false
                                    self.mealImage.alpha = 1.0 },
                                   completion: { _ in })
                    
                } else {
                    self.mealLabel.isHidden = false
                    UIView.animate(withDuration: 0.2, animations: {
                                    self.mealImage.alpha = 0.0},
                                   completion: {_ in
                                    self.mealImage.isHidden = true })
                }
            }.disposed(by: disposeBag)
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
}

class FlipButton: UIButton {
    convenience init(label: AccessibilityString) {
        self.init()
        self.setAccessibility(label)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(Asset.mealFlip.image, for: .normal)
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 45, height: 45)
    }
    
}
