//
//  AlbumTableViewCell.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/08/26.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final public class AlbumCollectionViewCell: UICollectionViewCell {
    private let image = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        $0.isSkeletonable = true
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Public Methods
    
    public func setupView(image: String) {
        DispatchQueue.main.async {
            self.image.kf.setImage(with: URL(string: image), placeholder: nil, options: nil, progressBlock: { _, _ in
                self.image.showAnimatedGradientSkeleton()
            }, completionHandler: { _ in self.image.hideSkeleton() })
        }
    }
    
    // MARK: Private Methods
    
    private func setupSubview() {
        addSubview(image)
        
        image.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}
