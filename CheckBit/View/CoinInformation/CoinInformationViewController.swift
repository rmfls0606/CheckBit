//
//  CoinInformationViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/6/25.
//

import UIKit
import SnapKit

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
    
    private(set) lazy var textFieldBox: UIView = {
        let view = UIView()
        view.addSubview(textField)
        view.layer.borderColor = UIColor(resource: .secondary).cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력해주세요."
        
        let iconImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconImageView.tintColor = UIColor(resource: .secondary)
        textField.leftView = iconImageView
        textField.leftViewMode = .always
        
        textField.backgroundColor = .white
        textField.textColor = UIColor(resource: .secondary)
        textField.font = UIFont.systemFont(ofSize: 16)
        
        textField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor(resource: .secondary)])
        textField.returnKeyType = .search
        
        return textField
    }()

    private let popularSearchView = PopularSearchesView()
    
    
    override func viewDidLayoutSubviews() {
        textFieldBox.layer.cornerRadius = textFieldBox.bounds.height / 2
        textFieldBox.layer.masksToBounds = true
    }
    
    override func configureHierarchy() {
        self.view.addSubview(textFieldBox)
        self.view.addSubview(popularSearchView)
    }
    
    override func configureLayout() {
        self.textFieldBox.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        self.popularSearchView.snp.makeConstraints { make in
            make.top.equalTo(textFieldBox.snp.bottom).offset(10)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
    }
    
    override func configureBind() {
        
    }
}

