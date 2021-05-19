//
//  MealPictureViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit

class MealPictureViewController: UIViewController {
    let viewModel: MealViewModel
    let date: String
    
    init(viewModel: MealViewModel, date: String) {
        self.viewModel = viewModel
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
