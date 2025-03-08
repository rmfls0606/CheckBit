//
//  CoinTableViewCell.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import UIKit
import SnapKit

class CoinTableViewCell: BaseTableViewCell {
    
    static let identifier = "CoinTableViewCell"

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [coinLabel, currentPriceLabel, changeStackView, tradePriceLabel])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 4
        view.alignment = .top
        return view
    }()
    
    private(set) var coinLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private(set) var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var changeStackView: UIStackView = {
        let view = UIStackView( arrangedSubviews: [changeRateLabel, changePriceLabel] )
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 2
        view.alignment = .trailing
        return view
    }()
    
    private(set) var changeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private(set) var changePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        return label
    }()
    
    private(set) var tradePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .main)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
    
    override func configureHierarchy() {
        self.contentView.addSubview(stackView)
    }
    
    override func configureLayout() {
        self.stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        self.backgroundColor = .white
        self.selectionStyle = .none
    }

}
