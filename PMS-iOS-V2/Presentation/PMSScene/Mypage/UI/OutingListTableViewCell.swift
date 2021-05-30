//
//  OutingListTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/28.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class OutingListTableViewCell: UITableViewCell {
    private let noticeStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10.0
        $0.alignment = .leading
    }
    
    private let colorView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = Colors.black.color
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    private let cellBackground = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
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
    
    func setupView(model: Outing) {
//        DispatchQueue.main.async {
//            if !model.type {
//                self.colorView.backgroundColor = Colors.red.color
//            } else {
//                self.colorView.backgroundColor = Colors.blue.color
//            }
//            self.titleLabel.text = model.notice.title
//            self.dateLabel.text = model.notice.date
//        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([cellBackground, colorView, noticeStack])
        noticeStack.addArrangeSubviews([titleLabel, dateLabel])
        colorView.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(3)
            $0.top.equalTo(cellBackground.snp_topMargin).offset(5)
            $0.leading.equalTo(cellBackground.snp_leadingMargin).offset(10)
        }
        noticeStack.snp.makeConstraints {
            $0.width.equalToSuperview().offset(-20)
            $0.top.equalTo(cellBackground.snp_topMargin).offset(5)
            $0.leading.equalTo(cellBackground.snp_leadingMargin).offset(20)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(15)
        }
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(10)
        }
        cellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
}
