//
//  MentionTableView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/26.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final public class MentionTableViewCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.textColor = .darkGray
        $0.font = UIFont.systemFont(ofSize: 20)
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
    
    public func setupView(text: String) {
        self.titleLabel.text = text
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.center.equalToSuperview()
        }
    }
}
