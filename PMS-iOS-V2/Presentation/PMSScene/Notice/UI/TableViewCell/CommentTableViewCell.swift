//
//  CommentTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final public class CommentTableViewCell: UITableViewCell {
    private let commentStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5.0
        $0.alignment = .leading
    }
    
    private let conetentStack = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = Colors.black.color
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.textAlignment = .right
    }
    
    private let userLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        $0.textAlignment = .left
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
    
    public func setupView(model: Comment) {
        DispatchQueue.main.async {
            self.contentLabel.text = model.body
            self.userLabel.text = model.user.name
            self.dateLabel.text = String(Array(model.date)[5...9]).replacingOccurrences(of: "-", with: " / ")
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([cellBackground, commentStack])
        commentStack.addArrangeSubviews([conetentStack, userLabel])
        conetentStack.addArrangeSubviews([contentLabel, dateLabel])
        
        commentStack.snp.makeConstraints {
            $0.top.equalTo(cellBackground).offset(15)
            $0.leading.equalTo(cellBackground.snp_leadingMargin).offset(10)
            $0.trailing.equalTo(cellBackground.snp_trailingMargin).offset(-10)
        }
        
        conetentStack.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.height.equalTo(15)
        }
        userLabel.snp.makeConstraints {
            $0.height.equalTo(10)
        }
        cellBackground.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(UIFrame.width - 70)
        }
    }
}
