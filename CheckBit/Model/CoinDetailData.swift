//
//  CoinDetailData.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation

struct CoinDetail: Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let market_cap: Double
    let market_cap_rank: Int
    let fully_diluted_valuation: Double?
    let total_volume: Double
    let high_24h: Double?
    let low_24h: Double?
    let price_change_24h: Double?
    let price_change_percentage_24h: Double?
    let market_cap_change_24h: Double?
    let market_cap_change_percentage_24h: Double?
    let circulating_supply: Double?
    let total_supply: Double?
    let max_supply: Double?
    let ath: Double
    let ath_change_percentage: Double
    let ath_date: String
    let atl: Double
    let atl_change_percentage: Double
    let atl_date: String
    let roi: CoinROI?
    let last_updated: String
    let sparkline_in_7d: SparklineData?
    let priceChangePercentage7dInCurrency: Double?
    
}

// MARK: - 코인 투자 수익률 정보
struct CoinROI: Decodable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}

// MARK: - 스파크라인 차트 데이터
struct SparklineData: Decodable {
    let price: [Double]
}
