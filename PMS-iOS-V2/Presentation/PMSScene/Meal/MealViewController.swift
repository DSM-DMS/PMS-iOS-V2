//
//  MealViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

class MealViewController: UIViewController {
    let viewModel: MealViewModel
    private let collectionView = UICollectionView(frame: .init(x: 0, y: 0, width: UIFrame.width, height: UIFrame.height / 1.7), collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 20
        $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    private let leftButton = LeftArrowButton()
    private let rightButton = RightArrowButton()
    
    init(viewModel: MealViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setupSubview()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubViews([leftButton, rightButton])
        view.addSubview(activityIndicator)
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension MealViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 70, height: view.frame.height)
    }
}
