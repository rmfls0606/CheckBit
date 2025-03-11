//
//  CoinDetailInvestmentView.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit

class CoinDetailInvestmentView: BaseView {

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerStakcView, groupBoxView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        return view
    }()
    
    private lazy var headerStakcView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, moreButton])
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.spacing = 4
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.text = "투자지표"
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더보기", for: .normal)
        button.setTitleColor(UIColor(resource: .secondary), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        
        if let image = UIImage(systemName: "chevron.right") {
            let resizedImage = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
            button.setImage(resizedImage, for: .normal)
        }
        
        button.tintColor = UIColor(resource: .secondary)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .right
        
        return button
    }()
    
    private lazy var groupBoxView: UIView = {
        let view = UIView()
        view.addSubview(marketValue)
        view.addSubview(fdv)
        view.addSubview(totalPrice)
        view.backgroundColor = UIColor(resource: .box)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var marketValue = titleAndContentStack(title: "", content: "")
    private lazy var fdv = titleAndContentStack(title: "", content: "")
    private lazy var totalPrice = titleAndContentStack(title: "", content: "")
    
    override func configureHierarchy() {
        self.addSubview(mainStackView)
    }
    
    override func configureLayout() {
        self.mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        self.groupBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        self.marketValue.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.fdv.snp.makeConstraints { make in
            make.top.equalTo(marketValue.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.totalPrice.snp.makeConstraints { make in
            make.top.equalTo(fdv.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        
    }

    func titleAndContentStack(title: String, content: String) -> UIStackView{
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 4
        
        let titleLabel: UILabel = {
           let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = UIColor(resource: .secondary)
            label.text = title
            return label
        }()
        
        let contentLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .bold)
            label.textColor = UIColor(resource: .main)
            label.text = content
            label.tag = 1
            return label
        }()
        
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(contentLabel)

        return view
    }
    
    func updateData(marketValue: Double, fdv: Double, totalPrice: Double){
        updateTitleAndContetStack(stackView: self.marketValue, content: marketValue.formatted2fValue())
        updateTitleAndContetStack(stackView: self.fdv, content: fdv.formatted2fValue())
        updateTitleAndContetStack(stackView: self.totalPrice, content: totalPrice.formatted2fValue())
    }
    
    func updateTitleAndContetStack(stackView: UIStackView, content: String){
        for subview in stackView.arrangedSubviews {
            if let label = subview as? UILabel {
                if label.tag == 1 {
                    label.text = "₩" + content
                    label.font = .systemFont(ofSize: 14, weight: .bold)
                    label.textColor = UIColor(resource: .main)
                }
            }
        }
    }
}
