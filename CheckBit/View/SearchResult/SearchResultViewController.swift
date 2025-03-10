//
//  SearchResultViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit

class SearchResultViewController: BaseViewController {
    
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
    }
    
    override func configureBind() {
        
    }
    
}
