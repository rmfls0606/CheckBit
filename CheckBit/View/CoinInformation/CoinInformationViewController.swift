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
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()
    
    private let popularSearchView = PopularSearchesView()
    private let popularNFTView = PopularNFTView()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor(resource: .secondary)
        return indicator
    }()
    
    
    override func viewDidLayoutSubviews() {
        textFieldBox.layer.cornerRadius = textFieldBox.bounds.height / 2
        textFieldBox.layer.masksToBounds = true
    }
    
    override func configureHierarchy() {
        self.view.addSubview(textFieldBox)
        self.view.addSubview(contentStackView)
        self.view.addSubview(loadingView)
        loadingView.addSubview(loadingIndicator)
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
        
        self.loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem( customView: navigationTitleLabel)
        
        self.popularNFTView.configureDelegate(delegate: self)
        self.navigationItem.title = ""
        
        loadingView.isHidden = false
        loadingIndicator.startAnimating()
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    override func configureBind() {
        let input = CoinInformationViewModel.Input(textFieldButtonTap: textField.rx.controlEvent(.editingDidEndOnExit), textFieldText: textField.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        popularSearchView.popularCollectionView.rx.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                guard let coin = owner.popularSearchView.dataSource.itemIdentifier(for: indexPath) else { return }
                let nextVC = CoinDetailViewController()
                let data = coin.item
                nextVC.coin = SearchCoin(
                    id: data.id,
                    name: data.name,
                    api_symbol: data.symbol,
                    symbol: data.symbol,
                    market_cap_rank: data.market_cap_rank,
                    thumb: data.thumb,
                    large: data.large
                )
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.dateString
            .subscribe(with: self) { owner, value in
                owner.popularSearchView.updateDateString(date: value)
            }
            .disposed(by: disposeBag)
        
        output.trendingList
            .map{ Array($0.prefix(14)) }
            .subscribe(with: self, onNext: { owner, value in
                owner.popularSearchView.updateSnapshot(trendingList: value)
            })
            .disposed(by: disposeBag)
        
        output.nftList
            .map{ Array($0.prefix(7)) }
            .bind(to: popularNFTView.nftCollectionView.rx.items(cellIdentifier: PopularNFTCollectionViewCell.identifier, cellType: PopularNFTCollectionViewCell.self)){
                (row, element, cell) in
                cell.insertData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.searchResult
            .subscribe(with: self) { owner, text in
                owner.view.endEditing(true)
                
                if !text.isEmpty {
                    let nextVC = SearchResultViewController()
                    nextVC.searchBar.text = text
                    owner.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(output.trendingList, output.nftList)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, data in
                owner.loadingIndicator.stopAnimating()
                owner.loadingView.isHidden = true
                owner.tabBarController?.tabBar.isUserInteractionEnabled = false
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
