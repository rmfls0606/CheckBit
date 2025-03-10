//
//  PopularNFTCollectionViewCell.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit
import SnapKit
import Kingfisher

class PopularNFTCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PopularNFTCollectionViewCell"
    
    private(set) var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(resource: .main)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var nftInfoLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = UIColor(resource: .secondary)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nftChangeStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nftArrowImageView, nftChangeRateLabel])
        view.axis = .horizontal
        view.spacing = 1
        view.distribution = .fill
        view.alignment = .center
        return view
    }()
    
    private(set) var nftArrowImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) var nftChangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .bold)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nftImageView.image = nil
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(nftImageView)
        self.contentView.addSubview(nftNameLabel)
        self.contentView.addSubview(nftInfoLabel)
        self.contentView.addSubview(nftChangeStackView)
    }
    
    override func configureLayout() {
        self.nftImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(72)
        }
        
        self.nftNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nftImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        self.nftInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(nftNameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
        
        self.nftChangeStackView.snp.makeConstraints { make in
            make.top.equalTo(nftInfoLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        self.nftArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
    
    override func configureView() {
        
    }
    
    func insertData(data: TrendingNFTItem){
        if let url = URL(string: data.thumb){
            self.nftImageView.kf.setImage(with: url)
        }else{
            self.nftImageView.image = UIImage(systemName: "person")
        }
        self.nftNameLabel.text = data.name
        self.nftInfoLabel.text = data.data.floor_price
        
        let newColor: UIColor
        var arrowImage: String = ""
        
        if data.floor_price_24h_percentage_change > 0{
            newColor = CoinChangeColor.rise.textColor
            arrowImage = ArrowImage.up.rawValue
        }else if data.floor_price_24h_percentage_change < 0{
            newColor = CoinChangeColor.fall.textColor
            arrowImage = ArrowImage.down.rawValue
        }else{
            newColor = CoinChangeColor.even.textColor
        }
        
        self.nftArrowImageView.image = UIImage(systemName: arrowImage)
        self.nftArrowImageView.tintColor = newColor
        self.nftChangeRateLabel.text = data.floor_price_24h_percentage_change.formatted2fValue() + "%"
        self.nftChangeRateLabel.textColor = newColor
    }
}
