//
//  SuccessLottieView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/22.
//

import UIKit
import Lottie
import Then

final public class SuccessLottieView: UIView {
    private let animationView = AnimationView(name: "success")
    private let label = UILabel()
    
    public convenience init(text: LocalizedString) {
        self.init()
        label.setText(text)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.white.color
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = Colors.gray.color.cgColor
        self.layer.shadowRadius = 3
        
        addSubview(animationView)
        addSubview(label)
        animationView.frame = animationView.superview!.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .playOnce
        
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-15)
            $0.width.height.equalTo(UIFrame.width / 3.3)
        }
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(animationView.snp_bottomMargin).offset(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIFrame.width / 1.75, height: UIFrame.width / 1.75)
    }
    
}
