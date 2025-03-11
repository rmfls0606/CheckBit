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
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(resource: .secondary)
        return indicator
    }()
    
    private let viewModel = TransactionViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func configureHierarchy() {
        self.view.addSubview(headerView)
        self.view.addSubview(coinTableView)
        self.view.addSubview(loadingView)
        loadingView.addSubview(loadingIndicator)
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
        
        self.loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
        
        self.headerView.backgroundColor = UIColor(resource: .box)
        
        loadingView.isHidden = false
        loadingIndicator.startAnimating()
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    override func configureBind() {
        let input = TransactionViewModel.Input(currentPriceTap: headerView.headerCurrentPriceButton.rx.tap,
                                               comparePreDatTap: headerView.headerComparePreDayButton.rx.tap,
                                               tradePriceTap: headerView.headerTradePriceButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.coinList
            .bind(
                to: coinTableView.rx
                    .items(
                        cellIdentifier: CoinTableViewCell.identifier,
                        cellType: CoinTableViewCell.self
                    )
            ){ (row, element, cell) in
                let data = element
                cell.insertData(data: data)
                
                self.loadingIndicator.stopAnimating()
                self.loadingView.isHidden = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
            }
            .disposed(by: disposeBag)
        
        output.sortItem
            .subscribe(with: self) { owner, value in
                owner.headerView.updateCurrentPriceStyle(sortItem: value)
                owner.headerView.updateComparePreDayStyle(sortItem: value)
                owner.headerView.updateTradePriceStyle(sortItem: value)
            }
            .disposed(by: disposeBag)
    }
}
