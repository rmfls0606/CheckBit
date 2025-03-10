//
//  TrendingData.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import Foundation

//MARK: - 트렌딩 화면
struct TrendingCoins: Decodable {
    let coins: [TrendingCoinItem]
}

struct TrendingCoinItem: Decodable, Hashable {
    let item: TrendingCoinDetails
}

struct TrendingCoinDetails: Decodable, Hashable{
    let id: String
    let coin_id: Int
    let name: String
    let symbol: String
    let market_cap_rank: Int
    let thumb: String
    let small: String
    let large: String
    let slug: String
    let price_btc: Double
    let score: Int
    let data: TrendingCoinData
}

struct TrendingCoinData: Decodable, Hashable {
    let price: Double
    let price_btc: String
    let price_change_percentage_24h: [String: Double]
    let market_cap: String
    let market_cap_btc: String
    let total_volume: String
    let total_volume_btc: String
    let sparkline: String
    let content: TrendingContentInfo?
    
}

struct TrendingContentInfo: Decodable, Hashable  {
    let title: String?
    let description: String?
}
