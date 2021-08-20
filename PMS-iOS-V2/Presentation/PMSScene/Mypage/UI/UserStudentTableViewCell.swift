//
//  UserStudentTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/31.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final public class UserStudentTableViewCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.textColor = Colors.black.color
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.isUserInteractionEnabled = true
    }

    private let disposeBag = DisposeBag()
    
    public var delegate: StudentListDelegate?
    
    // MARK: - Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Colors.whiteGray.color
        setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(model: UsersStudent) {
        DispatchQueue.main.async {
            if model.number == UDManager.shared.studentNumber! {
                self.titleLabel.textColor = Colors.blue.color
            } else {
                self.titleLabel.textColor = Colors.black.color
            }
            self.titleLabel.text = String(model.number) + " " + model.name
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
