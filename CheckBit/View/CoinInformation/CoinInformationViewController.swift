//
//  CoinInformationViewController.swift
//  CheckBit
//
//  Created by 이상민 on 3/6/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CoinInformationViewController: BaseViewController {
    
    private let viewModel = CoinInformationViewModel()
    private let disposeBag = DisposeBag()
    
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
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularSearchView, popularNFTView])
        stack.axis = .vertical
        //        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private let popularSearchView = PopularSearchesView()
    private let popularNFTView = PopularNFTView()
    
    
    override func viewDidLayoutSubviews() {
        textFieldBox.layer.cornerRadius = textFieldBox.bounds.height / 2
        textFieldBox.layer.masksToBounds = true
    }
    
    override func configureHierarchy() {
        self.view.addSubview(textFieldBox)
        //        self.view.addSubview(popularSearchView)
        //        self.view.addSubview(popularNFTView)
        self.view.addSubview(contentStackView)
    }
    
    override func configureLayout() {
        self.textFieldBox.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(textFieldBox.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        //        self.popularSearchView.snp.makeConstraints { make in
        //            make.top.equalTo(textFieldBox.snp.bottom).offset(10)
        //            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        //        }
        //
        //        self.popularNFTView.snp.makeConstraints { make in
        //            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        //            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        //            make.height.equalTo(300)
        //        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
        
        self.popularNFTView.configureDelegate(delegate: self)
    }
    
    override func configureBind() {
        let input = CoinInformationViewModel.Input()
        let ouput = viewModel.transform(input: input)
        
        ouput.dateString
            .subscribe(with: self) { owner, value in
                owner.popularSearchView.updateDateString(date: value)
            }
            .disposed(by: disposeBag)
        
        ouput.trendingList
            .subscribe(with: self, onNext: { owner, value in
                owner.popularSearchView.updateSnapshot(trendingList: value)
            })
            .disposed(by: disposeBag)
        
        Observable.just(["1", "2", "3", "4", "5", "6", "7"])
            .bind(to: popularNFTView.nftCollectionView.rx.items(cellIdentifier: PopularNFTCollectionViewCell.identifier, cellType: PopularNFTCollectionViewCell.self)){
                (row, element, cell) in
                cell.nftImageView.image = UIImage(systemName: "person")
                cell.nftNameLabel.text = "Meebits"
                cell.nftInfoLabel.text = "0.66 ETH"
                cell.nftArrowImageView.image = UIImage(systemName: "chevron.right")
                cell.nftChangeRateLabel.text = "12.34%"
            }
            .disposed(by: disposeBag)
    }
}

extension CoinInformationViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.height
        return CGSize(width: 72, height: height)
    }
}
