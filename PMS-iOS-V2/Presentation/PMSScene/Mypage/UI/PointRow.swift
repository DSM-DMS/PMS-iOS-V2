//
//  PointRow.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/29.
//

import UIKit

final public class PlusPointRow: UIView {
    private let pointlabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.text = "00"
        $0.textColor = UIColor.black
    }
    
    private let pointTitle = UILabel().then {
        $0.text = LocalizedString.plusScore.localized
        $0.textColor = Colors.blue.color
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
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
    
    public func setupView(plus: Int) {
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

final public class MinusPointRow: UIView {
    private let pointlabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.text = "00"
        $0.textColor = UIColor.black
    }
    
    private let pointTitle = UILabel().then {
        $0.text = LocalizedString.minusScore.localized
        $0.textColor = Colors.red.color
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
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
