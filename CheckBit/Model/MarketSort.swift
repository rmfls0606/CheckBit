//
//  MarketSort.swift
//  CheckBit
//
//  Created by 이상민 on 3/9/25.
//

import Foundation

enum SortType{case desc, asc}

enum SortItem{
    case currentPrice(SortType)
    case comaprePreDay(SortType)
    case tradePrice(SortType)
    
    var sortCoinList: ([MarketData]) -> [MarketData]{
        switch self{
        case .currentPrice(let option):
            return { coinList in
                coinList.sorted{ option == .desc ? $0.trade_price > $1.trade_price : $0.trade_price < $1.trade_price }
            }
        case .comaprePreDay(let option):
            return { coinList in
                coinList.sorted { option == .desc ? $0.signed_change_rate > $1.signed_change_rate : $0.signed_change_rate < $1.signed_change_rate }
            }
        case .tradePrice(let option):
            return { coinList in
                coinList.sorted { option == .desc ? $0.acc_trade_price > $1.acc_trade_price : $0.acc_trade_price < $1.acc_trade_price }
            }
        }
    }
}
