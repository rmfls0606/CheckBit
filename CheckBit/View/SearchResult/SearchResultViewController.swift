//
//  SearchResultViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .white
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        searchBar.searchTextField.textColor = UIColor(resource: .secondary)
        return searchBar
    }()
    
    private let searcnResultView = SearchResultView()

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
        
    }
    
}
