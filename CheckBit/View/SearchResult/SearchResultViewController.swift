//
//  SearchResultViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultViewController: BaseViewController {
    
    private(set) var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.textColor = UIColor(resource: .secondary)
        return searchBar
    }()
    
    private let searcnResultView = SearchResultView()
    private let disposeBag = DisposeBag()
    private let viewModel = SearchResultViewModel()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searcnResultView.searchResultTableView.reloadData()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(searcnResultView)
        self.view.addSubview(loadingView)
        loadingView.addSubview(loadingIndicator)
    }
    
    override func configureLayout() {
        self.searcnResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
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
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.hidesBackButton = true
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: nil)
        leftItem.tintColor = UIColor(resource: .main)
        self.navigationItem.leftBarButtonItem = leftItem
        
        loadingView.isHidden = false
        loadingIndicator.startAnimating()
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    
    override func configureBind() {
        let likeButtonTap = PublishRelay<String>()
        
        let input = SearchResultViewModel.Input(searchText: searchBar.rx.text.orEmpty, searchTap: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.searchResult
            .bind(to: searcnResultView.searchResultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)){
                (row, element, cell) in
                cell.insertData(data: element)
                
                cell.likeButtonTap
                    .bind(to: likeButtonTap)
                    .disposed(by: cell.disposeBag)
                
                self.loadingIndicator.stopAnimating()
                self.loadingView.isHidden = true
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(
                searcnResultView.searchResultTableView.rx
                    .modelSelected(SearchCoin.self),
                searcnResultView
                    .searchResultTableView.rx.itemSelected)
            .map{ $0 }
            .bind(with: self) { owner, coin in
                let nextVC = CoinDetailViewController()
                nextVC.coin = coin.0
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        likeButtonTap
            .subscribe(with: self) { owner, _ in
                owner.searcnResultView.searchResultTableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
}
