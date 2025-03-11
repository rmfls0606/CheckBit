//
//  SearchResultTableViewCell.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit
import Kingfisher

class SearchResultTableViewCell: BaseTableViewCell{
    
    static let identifier = "SearchResultTableViewCell"
    
    
    private let resultImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let resultNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(resource: .main)
        return label
    }()
    
    private lazy var resultRankLabelView: UIView = {
        let view = UIView()
        view.addSubview(resultRankLabel)
        view.backgroundColor = UIColor(resource: .box)
        return view
    }()
    
    private let resultRankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = UIColor(resource: .secondary)
        return label
    }()
    
    private lazy var resultNameView: UIView = {
        let view = UIView()
        view.addSubview(resultNameLabel)
        view.addSubview(resultRankLabelView)
        return view
    }()
    
    private let resultSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(resource: .secondary)
        return label
    }()
    
    private lazy var resultInfoStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [resultNameView, resultSymbolLabel])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 2
        return view
    }()
    
    private let resultLikeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = UIColor(resource: .main)
        return button
        
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        resultRankLabelView.layer.cornerRadius = resultRankLabelView.bounds.height / 4
        resultRankLabelView.layer.masksToBounds = true
    }
    
    override func configureHierarchy() {
        self.contentView.addSubview(resultImageView)
        self.contentView.addSubview(resultInfoStackView)
        self.contentView.addSubview(resultLikeButton)
    }
    
    override func configureLayout() {
        self.resultImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.leading.centerY.equalToSuperview().inset(16)
        }
        
        self.resultInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(resultImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(resultLikeButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        self.resultNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        self.resultRankLabelView.snp.makeConstraints { make in
            make.leading.equalTo(resultNameLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualTo(resultInfoStackView.snp.trailing)
        }
        
        self.resultRankLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(4)
            make.verticalEdges.equalToSuperview().inset(2)
        }
        
        self.resultSymbolLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        self.resultLikeButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        self.selectionStyle = .none
        [resultRankLabelView, resultRankLabel].forEach {
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
    
    func insertData(data: SearchCoin){
        if let url = URL(string: data.thumb){
            self.resultImageView.kf.setImage(with: url)
        }else{
            self.resultImageView.image = UIImage(systemName: "person.circle")
        }
        
        self.resultNameLabel.text = data.name
        self.resultRankLabel.text = "#\(data.market_cap_rank)"
        self.resultSymbolLabel.text = data.api_symbol
    }
}
