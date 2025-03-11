//
//  CoinDetailChartView.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit

class CoinDetailChartView: BaseView {

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalPriceLabel, totalChangeStackView])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 4
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(resource: .main)
        label.text = "₩140,375,094"
        return label
    }()
    
    private lazy var totalChangeStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalChangeIconImageView, totalPercentageLabel])
        view.distribution = .fill
        view.axis = .horizontal
        view.spacing = 1
        return view
    }()
    
    private let totalPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.text = "0.98%"
        return label
    }()
    
    private let totalChangeIconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(systemName: ArrowImage.up.rawValue)
        return view
    }()
    
    override func configureHierarchy() {
        self.addSubview(mainStackView)
    }
    
    override func configureLayout() {
        self.mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        self.totalChangeIconImageView.snp.makeConstraints { make in
            make.size.equalTo(10)
        }
    }
    
    override func configureView() {
        
    }
}
