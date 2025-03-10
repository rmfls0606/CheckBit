//
//  SearchData.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation

struct SearchData: Decodable {
    let coins: [SearchCoin]
}

struct SearchCoin: Decodable {
    let id: String
    let name: String
    let api_symbol: String
    let symbol: String
    let market_cap_rank: Int
    let thumb: String
    let large: String
}

