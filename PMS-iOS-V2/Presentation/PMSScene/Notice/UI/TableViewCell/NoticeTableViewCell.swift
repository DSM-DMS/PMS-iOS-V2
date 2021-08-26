//
//  NoticeTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final public class NoticeTableViewCell: UITableViewCell {
    private let titleStack = UIStackView().then { $0.spacing = 10.0 }
    
    private let colorView = UIView().then { $0.backgroundColor = Colors.blue.color }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        $0.textColor = UIColor.black
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    private let cellBackground = UIView().then {
        $0.backgroundColor = Colors.lightGray.color
        $0.layer.cornerRadius = 15
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowColor = Colors.gray.color.cgColor
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    // MARK: - Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        shadow()
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: NoticeCell) {
        DispatchQueue.main.async {
            if model.type {
                self.colorView.backgroundColor = Colors.red.color
            } else {
                self.colorView.backgroundColor = Colors.blue.color
            }
            self.titleLabel.text = model.notice.title
            self.dateLabel.text = model.notice.date
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([cellBackground, titleStack, dateLabel])
        titleStack.addArrangeSubviews([colorView, titleLabel])
        colorView.snp.makeConstraints {
            $0.width.equalTo(3)
        }
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(cellBackground.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(cellBackground.snp_trailingMargin).offset(-20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp_bottomMargin)
            $0.leading.equalTo(titleStack.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(cellBackground.snp_trailingMargin).offset(-20)
        }
        cellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
}
