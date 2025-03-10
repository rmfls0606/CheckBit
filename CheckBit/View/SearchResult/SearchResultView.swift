//
//  SearchResultView.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit

class SearchResultView: BaseView {
    
    private let tabItems = TabItem.allCases
    private var buttons: [UIButton] = []
    
    private lazy var buttonStackView: UIStackView = {
        let buttons = tabItems.map{ item -> UIButton in
            let button = UIButton()
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(UIColor(resource: .secondary), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12)
            return button
        }
        let view = UIStackView(arrangedSubviews: buttons)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .secondary)
        return view
    }()
    
    private let searchResultTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .red
        return view
    }()

    override func configureHierarchy() {
        self.addSubview(buttonStackView)
        self.addSubview(bottomLineView)
        self.addSubview(searchResultTableView)
    }
    
    override func configureLayout() {
        self.buttonStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
