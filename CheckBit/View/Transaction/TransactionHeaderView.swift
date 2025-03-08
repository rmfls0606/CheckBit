//
//  TransactionHeaderVIew.swift
//  CheckBit
//
//  Created by 이상민 on 3/8/25.
//

import UIKit
import SnapKit

class TransactionHeaderView: BaseView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerCoinLabel, headerCurrentPriceLabel, headerComparePreDayLabel, headerTradPriceLabel])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 4
        return view
    }()
    
    private let headerCoinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(resource: .main)
        label.textAlignment = .left
        label.text = "코인"
        return label
    }()
    
    private lazy var headerCurrentPriceLabel: UIView = combineHeaderLabel(labelText: "현재가")
    
    private lazy var headerComparePreDayLabel: UIView = combineHeaderLabel(labelText: "전일대비")
    
    private lazy var headerTradPriceLabel: UIView = combineHeaderLabel(labelText: "거래대금")
    
    override func configureHierarchy() {
        self.addSubview(stackView)
    }
    
    override func configureLayout() {
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        
    }
    
    private func combineHeaderLabel(labelText: String) -> UIView {
        let label: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.textColor = UIColor(resource: .main)
            label.textAlignment = .right
            label.text = labelText
            return label
        }()
        
        
        let upImageView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(systemName: "arrowtriangle.up.fill")
            view.contentMode = .scaleAspectFill
            view.tintColor = UIColor(resource: .main)
            return view
        }()
        
        let downImageView = {
            let view = UIImageView()
            view.image = UIImage(systemName: "arrowtriangle.down.fill")
            view.contentMode = .scaleAspectFill
            view.tintColor = UIColor(resource: .main)
            return view
        }()

        upImageView.snp.makeConstraints { make in
            make.size.equalTo(6)
        }
        
        downImageView.snp.makeConstraints { make in
            make.size.equalTo(6)
        }
        
        let arrowVStackView: UIStackView = {
            let view = UIStackView(arrangedSubviews: [upImageView, downImageView])
            view.axis = .vertical
            view.distribution = .fillEqually
            view.alignment = .center
            view.spacing = 0
            return view
        }()
        
        let containerView: UIView = {
            let view = UIView()
            view.addSubview(label)
            view.addSubview(arrowVStackView)
            return view
        }()
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(label.snp.height)
        }
        
        label.snp.makeConstraints { make in
            make.trailing.equalTo(arrowVStackView.snp.leading).offset(-2)
            make.centerY.equalToSuperview()
        }
        
        arrowVStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return containerView
    }
}
