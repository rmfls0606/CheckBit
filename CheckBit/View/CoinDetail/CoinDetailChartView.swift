//
//  CoinDetailChartView.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import UIKit
import SnapKit
import DGCharts

class CoinDetailChartView: BaseView {
    private lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalPriceLabel, totalChangeStackView, chartView, updateLabel])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 4
        view.alignment = .fill
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(resource: .main)
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
        return label
    }()
    
    private let totalChangeIconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.rightAxis.enabled = false
        view.xAxis.enabled = false
        view.leftAxis.enabled = false
        view.legend.enabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        view.drawBordersEnabled = false
        view.isUserInteractionEnabled = false
        view.noDataText = "데이터가 존재하지 않습니다."
        view.noDataFont = .systemFont(ofSize: 12)
        view.noDataTextColor = UIColor(resource: .main)
        return view
    }()
    
    private let updateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = UIColor(resource: .secondary)
        return label
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
        
        self.chartView.snp.makeConstraints { make in
            make.height.equalTo(chartView.snp.width).multipliedBy(0.6)
        }
        
    }
    
    override func configureView() {
        
    }
    
    func updateChartView(values: [Double]){
        let entries = values.enumerated().map{ index, value in
            return ChartDataEntry(x: Double(index), y: value)
        }
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2.0
        dataSet.setColor(UIColor(resource: .fallingPrice))
        dataSet.drawCircleHoleEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        
        let gradientColors = [
            UIColor(resource: .fallingPrice).withAlphaComponent(1.0).cgColor,
            UIColor(resource: .fallingPrice).withAlphaComponent(0.5).cgColor,
            UIColor(resource: .fallingPrice).withAlphaComponent(0.3).cgColor
        ] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: [0.0, 0.5, 1.0])!
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
        dataSet.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        
        chartView.extraTopOffset = 0
        chartView.extraBottomOffset = 0
        chartView.extraLeftOffset = 0
        chartView.extraRightOffset = 0
        chartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
    }
    
    func insertData(currentPrice: Double, price_change_percentage_24h: Double, last_updated: String){
        self.totalPriceLabel.text = "₩" + currentPrice.formatted2fValue()
        
        let newColor: UIColor
        var arrowImageName: String = ""
        if price_change_percentage_24h > 0 {
            newColor = CoinChangeColor.rise.textColor
            arrowImageName = ArrowImage.up.rawValue
        }else if price_change_percentage_24h < 0 {
            newColor = CoinChangeColor.fall.textColor
            arrowImageName = ArrowImage.down.rawValue
        }else{
            newColor = CoinChangeColor.even.textColor
        }
        
        self.totalChangeIconImageView.image = UIImage(systemName: arrowImageName)
        self.totalChangeIconImageView.tintColor = newColor
        self.totalPercentageLabel.textColor = newColor
        self.totalPercentageLabel.text = abs(price_change_percentage_24h).formatted2fValue()
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = isoFormatter.date(from: last_updated) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd HH:mm:ss '업데이트'"
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            
            self.updateLabel.text = formatter.string(from: date)
        } else {
            self.updateLabel.text = "--"
        }
    }
}
