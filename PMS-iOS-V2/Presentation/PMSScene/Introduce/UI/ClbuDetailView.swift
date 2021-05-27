//
//  DetailClubView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/27.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class ClubDetailView: UIView {
    private let noticeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 15.0
    }
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }
    
    private let titleLabel = UILabel()
    
    private let titleLine = UIView().then { $0.backgroundColor = .lightGray }

    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    private let viewTextLabel = UILabel().then {
        $0.text = "| 조회수"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }

    private let viewLabel = UILabel().then {
        $0.text = "0"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    private let dateStackView = UIStackView().then {
//        $0.spacing = 10.0
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let descLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private let descLine = UIView().then { $0.backgroundColor = .darkGray }
    
    private let descStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }

    // MARK: - Initialization
    
    override func draw(_ rect: CGRect) {
        setupSubview()
    }

    // MARK: - Public Methods
    
    func setupView(model: DetailNotice) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descLabel.text = model.body
            self.dateLabel.text = model.date
        }
    }

    // MARK: Private Methods
    
    private func setupSubview() {
        addSubview(noticeStackView)
        noticeStackView.addArrangeSubviews([titleStackView, descStackView])
        titleStackView.addArrangeSubviews([titleLabel, dateStackView, titleLine])
        dateStackView.addArrangeSubviews([dateLabel, viewTextLabel, viewLabel])
        descStackView.addArrangeSubviews([descLabel, descLine])
        
        noticeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(15)
        }
        
        dateStackView.snp.makeConstraints {
            $0.height.equalTo(15)
        }
        
        titleStackView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        viewLabel.snp.makeConstraints {
            $0.width.equalTo(UIFrame.width / 2)
        }
        
        descStackView.snp.makeConstraints {
            $0.height.equalTo(self.frame.height - 70)
        }
        
        titleLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
        
        descLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
    }
}
