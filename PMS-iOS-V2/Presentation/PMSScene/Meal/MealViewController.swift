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
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 20
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        let collectionView = UICollectionView(frame: .init(), collectionViewLayout: flowLayout).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: "MealCollectionViewCell")
            $0.backgroundColor = .clear
        }
        return collectionView
    }()
    
    private let mealDataSource = RxCollectionViewSectionedReloadDataSource<ListSection<MealCell>>(configureCell: {  (_, collection, indexPath, meal) -> UICollectionViewCell in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "MealCollectionViewCell", for: indexPath) as! MealCollectionViewCell
            cell.setupView(model: meal)
            return cell
    })
    
    private let activityIndicator = UIActivityIndicatorView()
    private let disposeBag = DisposeBag()
    
    private let dateStatView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    let leftButton = LeftArrowButton()
    let dateLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.tintColor = Colors.black.color
    }
    let rightButton = RightArrowButton()
    
    init(viewModel: MealViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setNavigationTitle(title: .mealTitle, accessibilityLabel: .mealTitle, isLarge: true)
        self.setupSubview()
        self.bindOutput()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsManager.view_meal.log()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(dateStatView)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        dateStatView.addArrangeSubviews([leftButton, dateLabel, rightButton])
        dateStatView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide).offset(20)
            $0.width.equalTo(UIFrame.width - 70)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dateStatView.snp_bottomMargin).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.layoutMarginsGuide)
            $0.height.equalTo(UIFrame.height / 1.7)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        leftButton.rx.tap
            .bind(to: viewModel.input.previousButtonTapped)
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind(to: viewModel.input.nextButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput() {
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.viewDate
            .subscribe(onNext: {
                self.dateLabel.text = $0
            }).disposed(by: disposeBag)
        
        //        collectionView.rx.itemSelected
        //            .subscribe(onNext: { self.collectionView.deselectRow(at: $0, animated: true)})
        //            .disposed(by: disposeBag)
        
        viewModel.output.mealCellList
            .map { [ListSection<MealCell>(header: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: mealDataSource))
            .disposed(by: disposeBag)
    }
}

 extension MealViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 1.5, height: UIFrame.height / 2)
    }
 }
