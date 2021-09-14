//
//  AttachView.swift
//  PMS-iOS-V2
//
//  Created by GoEun Jeong on 2021/09/02.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

final public class AttachViewController: UIViewController {
    private var attach = [Attach]()
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView().then {
        $0.register(AttachTableViewCell.self, forCellReuseIdentifier: "AttachTableViewCell")
        $0.contentMode = .scaleAspectFit
        $0.rowHeight = 60
        $0.backgroundColor = Colors.whiteGray.color
    }
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ListSection<Attach>>(configureCell: {  (_, tableView, _, attach) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachTableViewCell") as! AttachTableViewCell
        cell.setupView(model: attach)
        return cell
    })
    
    // MARK: - Initialization
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        self.setupSubview()
    }
    
    public func setAttach(attach: [Attach]) {
        self.attach = attach
        self.tableView.reloadData()
    }
    
    private func setupSubview() {
        self.view.backgroundColor = Colors.whiteGray.color
        self.view.layer.cornerRadius = 20
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowColor = Colors.gray.color.cgColor
        self.view.layer.shadowRadius = 3
        self.view.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.view.layer.masksToBounds = true
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(UIFrame.width - 70)
            $0.height.equalTo(UIFrame.height / 4.5)
        }
    }
}

extension AttachViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attach.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttachTableViewCell") as! AttachTableViewCell
        if !attach.isEmpty {
            cell.setupView(model: attach[indexPath.row])
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! AttachTableViewCell
        cell.changeDownload()
        FileDownloader.loadFileAsync(url: URL(string: self.attach[indexPath.row].download)!) { (path, _) in
            print("PDF File downloaded to : \(path!)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
