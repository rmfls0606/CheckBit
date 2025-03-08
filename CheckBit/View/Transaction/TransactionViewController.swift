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
    
    private let headerView = TransactionHeaderView()
    
    //CoinTableView
    private let coinTableView: UITableView = {
        let view = UITableView()
        view
            .register(
                CoinTableViewCell.self,
                forCellReuseIdentifier: CoinTableViewCell.identifier
            )
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.rowHeight = 40
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let viewModel = TransactionViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        self.view.addSubview(headerView)
        self.view.addSubview(coinTableView)
    }
    
    override func configureLayout() {
        self.headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        self.coinTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
        
        self.headerView.backgroundColor = UIColor(resource: .box)
    }
    
    override func configureBind() {
        let input = TransactionViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.coinList
            .bind(
                to: coinTableView.rx
                    .items(
                        cellIdentifier: CoinTableViewCell.identifier,
                        cellType: CoinTableViewCell.self
                    )
            ){ (row, element, cell) in
                cell.coinLabel.text = element.market
                cell.currentPriceLabel.text = element.trade_price
                    .formatted1fValue()
                cell.changeRateLabel.text = (element.signed_change_rate
                    .formatted2fValue() + "%")
                cell.changePriceLabel.text = element.signed_change_price
                    .formatted2fValue()
                cell.tradePriceLabel.text = element.acc_trade_price
                    .formattedMillionValue()
            }
            .disposed(by: disposeBag)
    }
}
