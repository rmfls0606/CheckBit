//
//  MarketData.swift
//  CheckBit
//
//  Created by 이상민 on 3/8/25.
//

import Foundation

struct MarketData: Decodable {
    let market: String
    let trade_date: String
    let trade_time: String
    let trade_date_kst: String
    let trade_time_kst: String
    let trade_timestamp: Int64
    let opening_price: Double
    let high_price: Double
    let low_price: Double
    let trade_price: Double
    let prev_closing_price: Double
    let change: String
    let change_price: Double
    let change_rate: Double
    let signed_change_price: Double
    let signed_change_rate: Double
    let trade_volume: Double
    let acc_trade_price: Double
    let acc_trade_price_24h: Double
    let acc_trade_volume: Double
    let acc_trade_volume_24h: Double
    let highest_52_week_price: Double
    let highest_52_week_date: String
    let lowest_52_week_price: Double
    let lowest_52_week_date: String
    let timestamp: Int64
}
