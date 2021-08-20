//
//  PointListTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/28.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final public class PointListTableViewCell: UITableViewCell {
    private let textStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5.0
        $0.alignment = .leading
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor.black
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    private let scoreLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
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
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: Point) {
        DispatchQueue.main.async {
            if !model.type {
                self.scoreLabel.textColor = Colors.red.color
                self.scoreLabel.text = "-" + String(model.point)
            } else {
                self.scoreLabel.textColor = Colors.blue.color
                self.scoreLabel.text = "+" + String(model.point)
            }
            self.titleLabel.text = model.reason
            self.dateLabel.text = model.date
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([cellBackground, textStack, scoreLabel])
        textStack.addArrangeSubviews([titleLabel, dateLabel])
        
        textStack.snp.makeConstraints {
            $0.centerY.equalTo(cellBackground)
            $0.width.equalToSuperview().offset(-20)
            $0.top.equalTo(cellBackground.snp_topMargin).offset(5)
            $0.leading.equalTo(cellBackground.snp_leadingMargin).offset(20)
        }
        scoreLabel.snp.makeConstraints {
            $0.trailing.equalTo(cellBackground.snp_trailingMargin).offset(-20)
            $0.centerY.equalToSuperview()
        }
        cellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(70)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
}
