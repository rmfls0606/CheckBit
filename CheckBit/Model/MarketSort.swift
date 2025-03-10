//
//  MarketSort.swift
//  CheckBit
//
//  Created by 이상민 on 3/9/25.
//

import Foundation

enum SortType{case desc, asc, none}

enum SortItem{
    case currentPrice(SortType)
    case comparePreDay(SortType)
    case tradePrice(SortType)
    
    var currentPriceOption: SortType{
        if case .currentPrice(let option) = self {
            return option
        }
        return .none
    }
    
    var comparPredDayOptoin: SortType{
        if case .comparePreDay(let option) = self {
            return option
        }
        return .none
    }
    
    var tradePriceOption: SortType{
        if case .tradePrice(let option) = self {
            return option
        }
        return .none
    }
    
    var sortCoinList: ([MarketData]) -> [MarketData]{
        switch self{
        case .currentPrice(let option):
            return { coinList in
                coinList.sorted{ option == .desc ? $0.trade_price > $1.trade_price : (option == .asc ? $0.trade_price < $1.trade_price : $0.acc_trade_price > $1.acc_trade_price) }
            }
        case .comparePreDay(let option):
            return { coinList in
                coinList.sorted { option == .desc ? $0.signed_change_rate > $1.signed_change_rate : (option == .asc ? $0.signed_change_rate < $1.signed_change_rate : $0.acc_trade_price > $1.acc_trade_price) }
            }
        case .tradePrice(let option):
            return { coinList in
                coinList.sorted { option == .asc ? $0.acc_trade_price < $1.acc_trade_price : $0.acc_trade_price > $1.acc_trade_price }
            }
        }
    }
}
