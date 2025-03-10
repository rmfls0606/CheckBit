//
//  PopularNFTView.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import UIKit

class PopularNFTView: BaseView {

    private let popularTitleLable: UILabel = {
        let label = UILabel()
        label.text = "인기 NFT"
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override func configureHierarchy() {
        self.addSubview(popularTitleLable)
    }
    
    override func configureLayout() {
        self.popularTitleLable.snp.makeConstraints { make in
            self.popularTitleLable.snp.makeConstraints { make in
                make.leading.top.equalToSuperview().inset(16)
            }
        }
    }
    
    override func configureView() {
        
    }
}
