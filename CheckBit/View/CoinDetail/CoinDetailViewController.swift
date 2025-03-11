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
    private let viewModel = CoinDetailViewModel()
    
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
    
    private let coinDetailChartView = CoinDetailChartView()
    private let coinDetailInfoView = CoinDetailInfoView()
    private let coinDatilInvestmentView = CoinDetailInvestmentView()
    
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [coinDetailChartView, coinDetailInfoView, coinDatilInvestmentView])
        view.axis = .vertical
        view.spacing = 20
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    
    
    override func configureHierarchy() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        self.view.addSubview(navTitleView)
    }
    
    override func configureLayout() {
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(scrollView)
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
        let input = CoinDetailViewModel.Input(coinIds: Observable<String>.just(coin!.id), likeButtonTap: self.navigationItem.rightBarButtonItem!.rx.tap)
        let output = viewModel.transform(input: input)
        
        self.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    
        output.price_in_7d_list
            .subscribe(with: self) { owner, value in
                let data = value.first!
                owner.coinDetailChartView.insertData(currentPrice: data.current_price, price_change_percentage_24h: data.price_change_percentage_24h ?? 0, last_updated: data.last_updated)
                owner.coinDetailChartView.updateChartView(values: data.sparkline_in_7d!.price)
                owner.coinDetailInfoView.updateData(highPrice_24h: data.high_24h ?? 0, lowPrice_24h: data.low_24h ?? 0, highPrice_all: data.ath, lowPrice_all: data.atl, hightDate: data.ath_date, lowDate: data.atl_date)
                owner.coinDatilInvestmentView.updateData(marketValue: data.market_cap, fdv: data.fully_diluted_valuation ?? 0, totalPrice: data.total_volume)
            }
            .disposed(by: disposeBag)
        
        output.isLiked
            .subscribe(with: self) { owner, state in
                let image = state ? "star.fill" : "star"
                owner.navigationItem.rightBarButtonItem?.image = UIImage(systemName: image)
            }
            .disposed(by: disposeBag)
    }
}
