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
        let view = UIStackView(arrangedSubviews: [headerCoinLabel, headerCurrentPriceButton, headerComparePreDayButton, headerTradPriceButton])
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
    
    private(set) lazy var headerCurrentPriceButton: UIButton = combineHeaderButton(labelText: "현재가")
    
    private(set) lazy var headerComparePreDayButton: UIButton = combineHeaderButton(labelText: "전일대비")
    
    private(set) lazy var headerTradPriceButton: UIButton = combineHeaderButton(labelText: "거래대금")
    
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
    
    private func combineHeaderButton(labelText: String) -> UIButton {
        let button = UIButton()
        
        button.setTitle(labelText, for: .normal)
        button.setTitleColor(UIColor(resource: .secondary), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        button.contentHorizontalAlignment = .right

        let upImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.up.fill"))
        upImageView.contentMode = .scaleAspectFill
        upImageView.tintColor = UIColor(resource: .secondary)
        upImageView.snp.makeConstraints { make in
            make.size.equalTo(6)
        }
        
        let downImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        downImageView.contentMode = .scaleAspectFill
        downImageView.tintColor = UIColor(resource: .secondary)
        downImageView.snp.makeConstraints { make in
            make.size.equalTo(6)
        }
        
        let arrowVStack = UIStackView(arrangedSubviews: [upImageView, downImageView])
        arrowVStack.axis = .vertical
        arrowVStack.distribution = .fillEqually
        arrowVStack.alignment = .center
        arrowVStack.spacing = 0

        button.addSubview(arrowVStack)
        arrowVStack.snp.makeConstraints{ make in
            make.trailing.equalTo(button)
            make.centerY.equalTo(button)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return button
    }
}
