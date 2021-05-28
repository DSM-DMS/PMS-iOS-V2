//
//  IntroduceCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
//

import UIKit

class IntroduceRow: UIView {
    
    private let titleStackView = UIStackView().then { $0.spacing = 10.0 }
    private let _titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    private let colorView = UIView().then { $0.backgroundColor = Colors.blue.color }
    
    private let descLabel = UILabel().then { $0.textColor = .gray }
    
    private let background = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // MARK: - Initialization
    
    convenience init(title: LocalizedString, desc: LocalizedString) {
        self.init()
        self._titleLabel.text = title.localized
        self.descLabel.text = desc.localized
    }
    
    override func draw(_ rect: CGRect) {
        setupSubview()
    }
    
    // MARK: - Public Methods
    
    func setupView(model: DetailNotice) {
        DispatchQueue.main.async {
            self._titleLabel.text = model.title
            self.descLabel.text = model.body
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([background, titleStackView, descLabel])
        titleStackView.addArrangeSubviews([colorView, _titleLabel])
        
        titleStackView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        colorView.snp.makeConstraints {
            $0.width.equalTo(3)
        }
        
        descLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        background.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
