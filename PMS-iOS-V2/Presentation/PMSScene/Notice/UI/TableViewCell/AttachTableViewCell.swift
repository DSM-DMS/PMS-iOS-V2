//
//  AttachTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/09/02.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final public class AttachTableViewCell: UITableViewCell {
    private var attach: Attach?
    private let clipImage = ClipButton()
    
    private let titleLabel = UILabel().then {
        $0.textColor = Colors.black.color
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.isUserInteractionEnabled = true
    }
    
    private let downloadImage = UIImageView().then {
        $0.image = Asset.download.image
    }
    
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
    
    public func setupView(model: Attach) {
        self.attach = model
        DispatchQueue.main.async {
            self.titleLabel.text = model.name
        }
    }
    
    public func changeDownload() {
        DispatchQueue.main.async {
            self.downloadImage.image = Asset.check.image
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([clipImage, titleLabel, downloadImage])
        
        clipImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(clipImage.snp_trailingMargin).offset(20)
            $0.trailing.equalToSuperview().offset(-30)
            $0.centerY.equalToSuperview()
        }
        
        downloadImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
}
