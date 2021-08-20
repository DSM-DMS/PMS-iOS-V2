//
//  StatusView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/28.
//

import UIKit

final public class StatusView: UIView {
    private let pointStatus = UIButton().then {
        $0.backgroundColor = Colors.blue.color
        $0.isUserInteractionEnabled = false
        $0.setTitle("-", for: .normal)
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    private let statusTitle = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        $0.text = LocalizedString.weekStatus.localized
    }
    
    private let statuslabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let mealTitle = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        $0.text = LocalizedString.weekendMealStatus.localized
    }
    
    private let mealImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let background = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = Colors.gray.color.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        setupSubview()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: Student) {
        DispatchQueue.main.async {
            self.pointStatus.setTitle( self.minusStatus(num: model.minus), for: .normal)
            self.statuslabel.text = self.convertStatus(num: model.status)
            if model.isMeal {
                self.mealImage.image = Asset.o.image
            } else {
                self.mealImage.image = Asset.x.image
            }
        }
    }
    
    private func convertStatus(num: Int) -> String {
        if num == 1 {
            return "금요귀가"
        } else if num == 2 {
            return "토요귀가"
        } else if num == 3 {
            return "토요귀사"
        } else if num == 4 {
            return "잔류"
        } else {
            return "오류가 났어요"
        }
    }
    
    private func minusStatus(num: Int) -> String {
        if UDManager.shared.student == nil {
            return "-"
        } else if num < 5 {
            return "아직 3월달인가요?"
        } else if num >= 5 && num < 10 {
            return "꽤 모범적이네요!"
        } else if num >= 10 && num < 15 {
            return "1차 봉사는 하셨나요?"
        } else if num >= 15 && num < 20 {
            return "2차 봉사는 하셨나요?"
        } else if num >= 20 && num < 25 {
            return "3차 봉사는 하셨나요?"
        } else if num >= 25 && num < 30 {
            return "벌점을 줄여주세요!!"
        } else if num >= 30 && num < 35 {
            return "곧 다벌점 교육이..."
        } else if num >= 35 && num < 40 {
            return "퇴사를 당하고 싶으신가요?"
        } else if num <= 40 {
            return "......"
        }
        return "-"
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([pointStatus, background])
        background.addSubViews([statusTitle, statuslabel, mealTitle, mealImage])
        
        pointStatus.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
        }
        
        background.snp.makeConstraints {
            $0.height.equalTo(90)
            $0.top.equalTo(pointStatus.snp_bottomMargin).offset(25)
            $0.width.equalToSuperview()
        }
        
        statusTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        statuslabel.snp.makeConstraints {
            $0.centerY.equalTo(statusTitle)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        mealTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        mealImage.snp.makeConstraints {
            $0.centerY.equalTo(mealTitle)
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
