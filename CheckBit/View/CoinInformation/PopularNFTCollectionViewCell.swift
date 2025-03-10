//
//  PopularNFTCollectionViewCell.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit
import SnapKit

class PopularNFTCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "PopularNFTCollectionViewCell"
    
    private(set) var nftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private(set) var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(resource: .main)
        return label
    }()
    
    private(set) var nftInfoLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = UIColor(resource: .secondary)
        return label
    }()
    
    private lazy var nftChangeStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nftArrowImageView, nftChangeRateLabel])
        view.axis = .horizontal
        view.spacing = 1
        view.distribution = .fill
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
            make.centerX.equalToSuperview()
        }
        
        self.nftInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(nftNameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        self.nftChangeStackView.snp.makeConstraints { make in
            make.top.equalTo(nftInfoLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
