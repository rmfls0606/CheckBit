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

    override func configureHierarchy() {
        self.view.addSubview(searcnResultView)
    }
    
    override func configureLayout() {
        self.searcnResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.titleView = self.searchBar
        self.navigationItem.hidesBackButton = true
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: nil)
        leftItem.tintColor = UIColor(resource: .main)
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    override func configureBind() {
        let input = SearchResultViewModel.Input(searchText: searchBar.rx.text.orEmpty, searchTap: searchBar.rx.searchButtonClicked)
        let output = viewModel.transform(input: input)
        
        output.searchResult
            .bind(to: searcnResultView.searchResultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)){
                (row, element, cell) in
                print(element)
            }
            .disposed(by: disposeBag)
    }
    
}
