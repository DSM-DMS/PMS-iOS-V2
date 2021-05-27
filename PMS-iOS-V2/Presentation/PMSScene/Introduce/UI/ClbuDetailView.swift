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
    private let upLine = UIView().then { $0.backgroundColor = .lightGray }
    
    private let clubImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let downLine = UIView().then { $0.backgroundColor = .darkGray }
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
    }
    
    private let descColorView = UIView().then { $0.backgroundColor = Colors.blue.color }
    
    private let descTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.text = LocalizedString.clubTitle.localized
    }
    
    private let descLabel = UILabel().then { $0.textColor = .gray }
    
    private let descBackground = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    private let memberColorView = UIView().then { $0.backgroundColor = Colors.blue.color }
    
    private let memberTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.text = LocalizedString.clubMember.localized
    }
    
    private let memberLabel = UILabel().then {
        $0.textColor = .gray
        $0.numberOfLines = 0
    }
    
    private let memberBackground = UIView().then {
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
    
    func setupView(model: DetailClub) {
        DispatchQueue.main.async {
            self.nameLabel.text = model.title
            self.descLabel.text = model.description
            self.memberLabel.text = model.member.joined(separator: ", ")
            
            self.clubImage.kf.setImage(with: (URL(string: model.imageUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!.replacingOccurrences(of: "%3A", with: ":"))))
        }
    }

    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([upLine, clubImage, downLine, nameLabel, descBackground, memberBackground])
        descBackground.addSubViews([descColorView, descTitle, descLabel])
        memberBackground.addSubViews([memberColorView, memberTitle, memberLabel])
        upLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
        
        clubImage.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-10)
            $0.height.equalTo(UIFrame.height / 3.5)
            $0.top.equalTo(upLine.snp_bottomMargin).offset(20)
        }
        
        downLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
            $0.top.equalTo(clubImage.snp_bottomMargin).offset(20)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(downLine.snp_bottomMargin).offset(20)
        }
        
        descColorView.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.height.equalTo(15)
            $0.top.equalTo(descBackground.snp_topMargin).offset(15)
            $0.leading.equalTo(descBackground.snp_leadingMargin).offset(10)
        }
        
        descTitle.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(descBackground.snp_topMargin).offset(15)
            $0.leading.equalTo(descColorView.snp_trailingMargin).offset(20)
            $0.trailing.equalTo(descBackground.snp_trailingMargin).offset(-10)
        }
        
        descLabel.snp.makeConstraints {
            $0.bottom.equalTo(descBackground.snp_bottomMargin).offset(-15)
            $0.leading.equalTo(descBackground.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(descBackground.snp_trailingMargin).offset(-10)
        }
        
        descBackground.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp_bottomMargin).offset(20)
            $0.height.equalTo(100)
            $0.width.equalToSuperview()
        }
        
        memberColorView.snp.makeConstraints {
            $0.width.equalTo(3)
            $0.height.equalTo(15)
            $0.top.equalTo(memberBackground.snp_topMargin).offset(15)
            $0.leading.equalTo(memberBackground.snp_leadingMargin).offset(10)
        }
        
        memberTitle.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(memberBackground.snp_topMargin).offset(15)
            $0.leading.equalTo(memberColorView.snp_trailingMargin).offset(20)
            $0.trailing.equalTo(memberBackground.snp_trailingMargin).offset(-10)
        }
        
        memberLabel.snp.makeConstraints {
            $0.bottom.equalTo(memberBackground.snp_bottomMargin).offset(-15)
            $0.leading.equalTo(memberBackground.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(memberBackground.snp_trailingMargin).offset(-10)
        }
        
        memberBackground.snp.makeConstraints {
            $0.top.equalTo(descBackground.snp_bottomMargin).offset(30)
            $0.height.equalTo(130)
            $0.width.equalToSuperview()
        }
    }
}
