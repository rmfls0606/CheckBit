//
//  TransactionHeaderVIew.swift
//  CheckBit
//
//  Created by 이상민 on 3/8/25.
//

import UIKit
import SnapKit

private enum ArrowImage: String {
    case up = "arrowtriangle.up.fill"
    case down = "arrowtriangle.down.fill"
}

class TransactionHeaderView: BaseView {
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerCoinLabel, headerCurrentPriceButton, headerComparePreDayButton, headerTradePriceButton])
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
    
    private(set) lazy var headerTradePriceButton: UIButton = combineHeaderButton(labelText: "거래대금")
    
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
        upImageView.tag = 1
        upImageView.snp.makeConstraints { make in
            make.size.equalTo(6)
        }
        
        let downImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        downImageView.contentMode = .scaleAspectFill
        downImageView.tintColor = UIColor(resource: .secondary)
        downImageView.tag = 2
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
    
    //MARK: - 선택에 따른 색상 변경 함수
    func updateHeaderButtonItemStyle(button: UIButton, expectedSortItem: Bool, sortType: SortType){
        let defaultColor = UIColor(resource: .secondary)
        let selectedColor = UIColor(resource: .main)
        
        let isSelectedSort = (expectedSortItem && sortType != .none)
        let newColor = isSelectedSort ? selectedColor : defaultColor
        
        button.setTitleColor(newColor, for: .normal)
        
        if let upImageView = button.viewWithTag(1) as? UIImageView,
           let downImageView = button.viewWithTag(2) as? UIImageView{
            
            if isSelectedSort{
                if sortType == .desc{
                    upImageView.image = UIImage(systemName: ArrowImage.up.rawValue)?
                        .withTintColor(defaultColor, renderingMode: .alwaysOriginal)
                    downImageView.image = UIImage(systemName: ArrowImage.down.rawValue)?
                        .withTintColor(newColor, renderingMode: .alwaysOriginal)
                }else if sortType == .asc {
                    upImageView.image = UIImage(systemName: ArrowImage.up.rawValue)?
                        .withTintColor(newColor, renderingMode: .alwaysOriginal)
                    downImageView.image = UIImage(systemName: ArrowImage.down.rawValue)?
                        .withTintColor(defaultColor, renderingMode: .alwaysOriginal)
                } else {
                    upImageView.image = UIImage(systemName: ArrowImage.up.rawValue)?
                        .withTintColor(defaultColor, renderingMode: .alwaysOriginal)
                    downImageView.image = UIImage(systemName: ArrowImage.down.rawValue)?
                        .withTintColor(defaultColor, renderingMode: .alwaysOriginal)
                }
            }else{
                upImageView.image = UIImage(systemName: ArrowImage.up.rawValue)?
                    .withTintColor(defaultColor, renderingMode: .alwaysOriginal)
                downImageView.image = UIImage(systemName: ArrowImage.down.rawValue)?
                    .withTintColor(defaultColor, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    func updateCurrentPriceStyle(sortItem: SortItem) {
        updateHeaderButtonItemStyle(button: headerCurrentPriceButton, expectedSortItem: {
            if case .currentPrice = sortItem { return true } else { return false }
        }(), sortType: sortItem.currentPriceOption)
    }
    
    // 편의 함수: comparePreDay 버튼 업데이트
    func updateComparePreDayStyle(sortItem: SortItem) {
        updateHeaderButtonItemStyle(button: headerComparePreDayButton, expectedSortItem: {
            if case .comparePreDay = sortItem { return true } else { return false }
        }(), sortType: sortItem.comparPredDayOptoin)
    }
    
    // 편의 함수: tradePrice 버튼 업데이트
    func updateTradePriceStyle(sortItem: SortItem) {
        updateHeaderButtonItemStyle(button: headerTradePriceButton, expectedSortItem: {
            if case .tradePrice = sortItem { return true } else { return false }
        }(), sortType: sortItem.tradePriceOption)
    }
    
}
