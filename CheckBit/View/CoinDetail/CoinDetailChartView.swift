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
        label.text = "2/15 18:00:45 업데이트"
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
}
