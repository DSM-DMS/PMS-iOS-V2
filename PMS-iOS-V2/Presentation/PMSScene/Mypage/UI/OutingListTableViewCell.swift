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

final public class OutingListTableViewCell: UITableViewCell {
    private let outingStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let dateStack = UIStackView().then {
        $0.spacing = 10.0
    }
    
    private let colorView = UIView()
    
    private let dateLabel = UILabel().then {
        $0.textColor = Colors.black.color
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    
    private let reasonLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.preferredFont(forTextStyle: .caption1)
    }
    
    private let placeLabel = UILabel().then {
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
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: Outing) {
        DispatchQueue.main.async {
            if model.type == "DISEASE" {
                self.colorView.backgroundColor = Colors.red.color
            } else {
                self.colorView.backgroundColor = Colors.blue.color
            }
            self.dateLabel.text = model.date
            self.reasonLabel.text = LocalizedString.outingReason.localized + " : " + model.reason
            self.placeLabel.text = LocalizedString.outingPlace.localized + " : " + model.place
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([cellBackground, colorView, outingStack])
        outingStack.addArrangeSubviews([dateStack, reasonLabel, placeLabel])
        dateStack.addArrangeSubviews([colorView, dateLabel])
        
        colorView.snp.makeConstraints {
            $0.width.equalTo(3)
        }
        
        outingStack.snp.makeConstraints {
            $0.top.equalTo(cellBackground.snp_topMargin).offset(10)
            $0.bottom.equalTo(cellBackground.snp_bottomMargin).offset(-10)
            $0.leading.equalTo(cellBackground.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(cellBackground.snp_trailingMargin).offset(-10)
        }
        
        cellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(110)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
}
