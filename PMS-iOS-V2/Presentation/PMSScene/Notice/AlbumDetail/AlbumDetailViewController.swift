//
//  AlbumDetailViewController.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then
import Reachability

final public class AlbumDetailViewController: UIViewController {
    internal let viewModel: AlbumDetailViewModel
    private let reachability = try! Reachability()
    private let activityIndicator = UIActivityIndicatorView()
    
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
    
    private let dateStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10.0
        $0.alignment = .leading
    }
    
    private let descLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 20
            $0.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        let collectionView = UICollectionView(frame: .init(), collectionViewLayout: flowLayout).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
            $0.backgroundColor = .clear
        }
        return collectionView
    }()
    
    private let dataSource = RxCollectionViewSectionedReloadDataSource<ListSection<String>>(configureCell: {  (_, collection, indexPath, imageUrl) -> UICollectionViewCell in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
            cell.setupView(image: imageUrl)
            return cell
    })
    
    private let disposeBag = DisposeBag()
    
    public init(viewModel: AlbumDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = viewModel.title
        self.setupSubview()
        self.bindOutput()
        self.collectionView.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try! reachability.startNotifier()
        AnalyticsManager.view_album_detail.log(name: viewModel.title)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }
    
    private func setupSubview() {
        view.backgroundColor = Colors.white.color
        view.addSubViews([titleStackView, collectionView])
        view.addSubview(activityIndicator)

        titleStackView.addArrangeSubviews([titleLabel, dateStackView])
        dateStackView.addArrangeSubviews([dateLabel, titleLine, descLabel])
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view.layoutMarginsGuide).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 50)
        }
        
        titleLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp_bottomMargin).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 50)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupView(model: DetailAlbum) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.dateLabel.text = model.date
            self.descLabel.text = model.body
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
        viewModel.output.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.detailNotice
            .subscribe { [weak self] notice in
                self?.setupView(model: notice)
            }.disposed(by: disposeBag)
        
        viewModel.output.detailNotice
            .map { [ListSection(header: "", items: $0.attach)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension AlbumDetailViewController: UICollectionViewDelegateFlowLayout {
   public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: UIFrame.height / 2, height: UIFrame.height / 2)
   }
}
