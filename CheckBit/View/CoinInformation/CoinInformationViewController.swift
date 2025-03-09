//
//  CoinInformationViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/6/25.
//

import UIKit

class CoinInformationViewController: BaseViewController {
    //NavigationTitle
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가상자산 / 심볼 검색"
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

