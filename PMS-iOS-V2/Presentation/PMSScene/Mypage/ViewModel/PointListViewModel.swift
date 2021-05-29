//
//  ScoreListViewModel.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import RxSwift
import RxCocoa
import RxFlow

class PointListViewModel: Stepper {
    let steps = PublishRelay<Step>()
    
}
