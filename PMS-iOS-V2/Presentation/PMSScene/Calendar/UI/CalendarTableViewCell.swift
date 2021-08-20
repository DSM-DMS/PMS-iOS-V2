//
//  CalendarTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/23.
//

import UIKit
import SnapKit
import Then

final public class CalendarTableViewCell: UITableViewCell {
    private let dateStack = UIStackView().then {
        $0.spacing = 15.0
    }
    
    private let circle = UIView().then {
        $0.layer.cornerRadius = 7.5
    }
    
    private let eventLabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray
    }
    
    private let calendarCellBackground = UIView().then {
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
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: CalendarCell) {
        DispatchQueue.main.async {
            if model.isHome != nil {
                self.circle.backgroundColor = model.isHome! ? Colors.red.color : Colors.green.color
                self.circle.isHidden = false
            } else {
                self.circle.isHidden = true
            }
            self.eventLabel.text = model.event
            if model.date != nil {
                self.dateLabel.text = model.date!
                self.dateLabel.isHidden = false
            } else {
                self.dateLabel.isHidden = true
            }
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubview(dateStack)
        dateStack.addSubview(calendarCellBackground)
        dateStack.addSubview(circle)
        dateStack.addArrangeSubviews([eventLabel, dateLabel])
        calendarCellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(55.0)
            $0.width.equalTo(UIFrame.width - 100)
        }
        dateStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        circle.snp.makeConstraints {
            $0.width.height.equalTo(15)
            $0.trailing.equalTo(dateStack.snp_leadingMargin).offset(-15)
            $0.centerY.equalToSuperview()
        }
    }
}
