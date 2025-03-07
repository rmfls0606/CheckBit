//
//  TransactionViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TransactionViewController: BaseViewController {
    //NavigationTitle
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "거래소"
        label.textColor = UIColor(resource: .main)
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    //CoinTableView
    private let coinTableView: UITableView = {
        let view = UITableView()
        view
            .register(
                UITableViewCell.self,
                forCellReuseIdentifier: "coinTableViewCell"
            )
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()
    
    private let viewModel = TransactionViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        self.view.addSubview(coinTableView)
    }
    
    override func configureLayout() {
        self.coinTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
    }
    
    override func configureBind() {
        let input = TransactionViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.coinList
            .bind(
                to: coinTableView.rx
                    .items(
                        cellIdentifier: "coinTableViewCell",
                        cellType: UITableViewCell.self
                    )
            ){ (row, element, cell) in
                cell.textLabel?.text = element.market
            }
            .disposed(by: disposeBag)
    }
}
