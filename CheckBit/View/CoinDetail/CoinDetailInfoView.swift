//
//  CoinDetailInfoView.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit

class CoinDetailInfoView: BaseView {
    
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
        label.text = "종목정보"
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
        view.addSubview(price_24h_stack)
        view.addSubview(price_all_stack)
        view.backgroundColor = UIColor(resource: .box)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var price_24h_stack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [highPrice_24h, fallPrice_24h])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    private lazy var price_all_stack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [highPrice_all, fallPrice_all])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 8
        return view
    }()
    
    private lazy var highPrice_24h = titleAndContentStack(title: "24시간 고가", content: "₩142,060,908")
    private lazy var fallPrice_24h = titleAndContentStack(title: "24시간 저가", content: "₩139,531,878")
    private lazy var highPrice_all = titleAndContentStack(title: "역대 최고가", content: "₩157,802,908", date: "25년 1월 20일")
    private lazy var fallPrice_all = titleAndContentStack(title: "역대 최저가", content: "₩75,594", date: "13년 7월 5일")
    
    
    override func configureHierarchy() {
        self.addSubview(mainStackView)
    }
    
    override func configureLayout() {
        self.mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        self.groupBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        self.price_24h_stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        self.price_all_stack.snp.makeConstraints { make in
            make.top.equalTo(price_24h_stack.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    func titleAndContentStack(title: String, content: String, date: String? = nil) -> UIStackView{
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
        
        if let date = date {
            let dateLabel: UILabel = {
                let label = UILabel()
                label.font = .systemFont(ofSize: 9)
                label.textColor = UIColor(resource: .secondary)
                label.text = date
                label.tag = 2
                return label
            }()
            view.addArrangedSubview(dateLabel)
        }
        
        
        return view
    }
    
    func updateData(highPrice_24h: Double, lowPrice_24h: Double, highPrice_all: Double, lowPrice_all: Double, hightDate: String?, lowDate: String?){
        updateTitleAndContetStack(stackView: self.highPrice_24h, content: highPrice_24h.formatted2fValue())
        updateTitleAndContetStack(stackView: self.fallPrice_24h, content: lowPrice_24h.formatted2fValue())
        updateTitleAndContetStack(stackView: self.highPrice_all, content: highPrice_all.formatted2fValue(), date: hightDate)
        updateTitleAndContetStack(stackView: self.fallPrice_all, content: lowPrice_all.formatted2fValue(), date: lowDate)
    }
    
    func updateTitleAndContetStack(stackView: UIStackView, content: String, date: String? = nil){
        for subview in stackView.arrangedSubviews {
            if let label = subview as? UILabel {
                if label.tag == 1 {
                    label.text = "₩" + content
                    label.font = .systemFont(ofSize: 14, weight: .bold)
                    label.textColor = UIColor(resource: .main)
                } else if label.tag == 2, let date = date {
                    label.text = formatISODate(date)
                    label.font = .systemFont(ofSize: 9)
                    label.textColor = UIColor(resource: .secondary)
                }
            }
        }
    }
    
    func formatISODate(_ isoDateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = isoFormatter.date(from: isoDateString) {
            let formatter = DateFormatter()
            formatter.dateFormat = "YY년 MM월 dd일"
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

            return formatter.string(from: date)
        } else {
            return "--"
        }
    }
}
