//
//  NoticeDetailView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final public class NoticeDetailView: UIView {
    public let clipButton = ClipButton()
    
    private let titleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5.0
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private let titleLine = UIView().then { $0.backgroundColor = .lightGray }

    private let dateLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    private let wrtierTextLabel = UILabel().then {
        $0.text = "| 작성자"
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }

    private let writerLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    private let dateStackView = UIStackView().then {
        $0.spacing = 10.0
        $0.alignment = .leading
    }
    
    private let descLabel = UITextView().then {
        $0.isScrollEnabled = true
    }
    
    private let descLine = UIView().then { $0.backgroundColor = .darkGray }
    
    private let descStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
    }

    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        setupSubview()
    }

    // MARK: - Public Methods
    
    public func setupView(model: DetailNotice) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descLabel.text = model.body
            self.dateLabel.text = model.date
            if model.writer == nil {
                self.wrtierTextLabel.isHidden = true
                self.writerLabel.isHidden = true
            } else {
                self.writerLabel.text = model.writer
                self.wrtierTextLabel.isHidden = false
                self.writerLabel.isHidden = false
            }
            if model.attach.isEmpty {
                self.clipButton.isHidden = true
            } else {
                self.clipButton.isHidden = false
            }
        }
    }

    // MARK: Private Methods
    
    private func setupSubview() {
        addSubViews([titleStackView, clipButton, descStackView])
        titleStackView.addArrangeSubviews([titleLabel, dateStackView])
        dateStackView.addArrangeSubviews([dateLabel, wrtierTextLabel, writerLabel])
        descStackView.addArrangeSubviews([titleLine, descLabel, descLine])
        
        clipButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(clipButton.snp_leadingMargin).offset(-15)
        }
        
        descStackView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp_bottomMargin).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
//            $0.height.equalTo(UIFrame.height / 3.5)
//            $0.centerX.equalToSuperview()
        }
        
//        descStackView.snp.makeConstraints {
//            $0.height.equalTo(self.frame.height - 70)
//        }
        
        titleLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
        
        descLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
    }
}
