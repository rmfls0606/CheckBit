//
//  CoinDetailViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class CoinDetailViewController: BaseViewController {
    
    var coin: SearchCoin?
    
    private let disposeBag = DisposeBag()
    
    private lazy var navTitleView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [navTitleImageView, navTitleLabel])
        view.axis = .horizontal
        view.spacing = 4
        return view
    }()
    
    private let navTitleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    
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
        self.view.addSubview(navTitleView)
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
        
        guard let coin = self.coin else { return }
        if let url = URL(string: coin.thumb){
            navTitleImageView.kf.setImage(with: url)
        }else{
            navTitleImageView.image = UIImage(systemName: "person.circle")
        }
        
        navTitleLabel.text = coin.name
        
        self.navigationItem.titleView = navTitleView
        
        self.navigationItem.hidesBackButton = true
        let leftButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .done,
            target: self,
            action: nil
        )
        leftButton.tintColor = UIColor(resource: .main)
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButtoon = UIBarButtonItem(
            image: UIImage(systemName: "star"),
            style: .plain,
            target: self,
            action: nil
        )
        rightButtoon.tintColor = UIColor(resource: .main)
        
        self.navigationItem.rightBarButtonItem = rightButtoon
    }
    
    override func configureBind() {
        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
