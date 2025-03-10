//
//  PopularCollectionViewCell.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit
import SnapKit
import Kingfisher

class PopularCollectionViewCell: BaseCollectionViewCell {
    private(set) var popularRankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(resource: .main)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var popularCoinImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private(set) var popularCoinNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(resource: .main)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private(set) var popularCoinCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = UIColor(resource: .secondary)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var coinNameStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [popularCoinNameLabel, popularCoinCompanyLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        view.distribution = .fill
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private(set) var popularChangeIconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) var popularChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var popularChangeStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [popularChangeIconImageView, popularChangeLabel])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 1
        view.distribution = .fill
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(popularRankLabel)
        view.addSubview(popularCoinImageView)
        view.addSubview(coinNameStackView)
        view.addSubview(popularChangeStackView)
        return view
    }()
    
    override func configureHierarchy() {
        self.contentView.addSubview(containerView)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popularRankLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        popularCoinImageView.snp.makeConstraints { make in
            make.leading.equalTo(popularRankLabel.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
            make.size.equalTo(26)
        }
        
        coinNameStackView.snp.makeConstraints { make in
            make.leading.equalTo(popularCoinImageView.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(popularChangeStackView.snp.leading).offset(-2)
        }
        
        popularChangeStackView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
        
        popularChangeIconImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
    
    override func configureView() {
        
    }
    
    func insertData(rank: Int, data: TrendingCoinItem){
        self.popularRankLabel.text = "\(rank)"
        
        if let url = URL(string: data.item.thumb){
            self.popularCoinImageView.kf.setImage(with: url)
        }else{
            self.popularCoinImageView.image = UIImage(systemName: "person.fill.circle")
        }
        
        self.popularCoinNameLabel.text = data.item.name
        self.popularCoinCompanyLabel.text = data.item.symbol
        self.popularChangeIconImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        
        if let changeRate = data.item.data.price_change_percentage_24h["krw"]{
            self.popularChangeLabel.text = changeRate.formatted2fValue() + "%"
            
            let newColor: UIColor
            var arrowImageName: String = ""
            if changeRate > 0{
                newColor = CoinChangeColor.rise.textColor
                arrowImageName = ArrowImage.up.rawValue
            }else if changeRate == 0{
                newColor = CoinChangeColor.even.textColor
            }else{
                newColor = CoinChangeColor.fall.textColor
                arrowImageName = ArrowImage.down.rawValue
            }
            
            self.popularChangeLabel.textColor = newColor
            self.popularChangeIconImageView.image = UIImage(systemName: arrowImageName)
            self.popularChangeIconImageView.tintColor = newColor
    
        }else{
            self.popularRankLabel.text = "-"
        }
    }
}
