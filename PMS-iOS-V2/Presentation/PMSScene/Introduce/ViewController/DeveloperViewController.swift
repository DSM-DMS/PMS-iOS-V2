//
//  DeveloperViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/05/19.
//

import UIKit
import Reachability
import RxSwift
import RxCocoa
import RxDataSources

final public class DeveloperViewController: UIViewController {
    internal let viewModel: DeveloperViewModel
    private let activityIndicator = UIActivityIndicatorView()
    private let reachability = try! Reachability()
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 20
            $0.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        }
        let collectionView = UICollectionView(frame: .init(), collectionViewLayout: flowLayout).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(DeveloperCollectionCell.self, forCellWithReuseIdentifier: "DeveloperCollectionCell")
            $0.backgroundColor = .clear
            $0.allowsSelection = false
        }
        return collectionView
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ListSection<Developer>>(configureCell: {  (_, collection, indexPath, club) -> UICollectionViewCell in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "DeveloperCollectionCell", for: indexPath) as! DeveloperCollectionCell
            cell.setupView(model: club)
            return cell
    })
    
    public init(viewModel: DeveloperViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.collectionView.delegate = self
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = LocalizedString.developerTitle.localized
        self.setupSubview()
        self.bindOutput()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
        AnalyticsManager.view_developers.log()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        reachability.rx.isDisconnected
            .bind(to: viewModel.input.noInternet)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.developerList
            .map { [ListSection<Developer>(header: "", items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension DeveloperViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: UIFrame.width / 2 - 50, height: UIFrame.width / 2 - 10)
   }
}
