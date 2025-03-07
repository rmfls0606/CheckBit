//
//  TransactionViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import UIKit

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
    
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
    }
    
    override func configureBind() {
        
    }
}
