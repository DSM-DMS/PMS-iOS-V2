//
//  PointRow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/29.
//

import UIKit

class PlusPointRow: UIView {
    private let pointlabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.text = "00"
    }
    
    private let pointTitle = UILabel().then {
        $0.text = LocalizedString.plusScore.localized
        $0.textColor = Colors.blue.color
    }
    
    private let background = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // MARK: - Initialization
    
    override func draw(_ rect: CGRect) {
        setupSubview()
    }
    
    // MARK: - Public Methods
    
    func setupView(plus: Int) {
        if plus > 10 {
            self.pointlabel.text = String(plus)
        } else {
            self.pointlabel.text = "0" + String(plus)
        }
       
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([background, pointlabel, pointTitle])
        
        pointlabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        pointTitle.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        background.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}

class MinusPointRow: UIView {
    private let pointlabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.text = "00"
    }
    
    private let pointTitle = UILabel().then {
        $0.text = LocalizedString.minusScore.localized
        $0.textColor = Colors.red.color
    }
    
    private let background = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // MARK: - Initialization
    
    override func draw(_ rect: CGRect) {
        setupSubview()
    }
    
    // MARK: - Public Methods
    
    func setupView(minus: Int) {
        self.pointlabel.text = String(minus)
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([background, pointlabel, pointTitle])
        
        pointlabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        pointTitle.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        background.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
