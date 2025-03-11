//
//  CoinDetailViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit

class CoinDetailViewController: BaseViewController {
    
    var coin: SearchCoin?
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.backgroundColor = .red
        return view
    }()
    
    override func configureHierarchy() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
    }
    
    override func configureLayout() {
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
    }
    
    override func configureBind() {
        
    }
}
