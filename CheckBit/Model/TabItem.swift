//
//  TabItem.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation

enum TabItem: Int, CaseIterable {
    case coin = 0
    case nft = 1
    case market = 2
    
    var title: String{
        switch self{
        case .coin:
            return "코인"
        case .nft:
            return "NFT"
        case .market:
            return "거래소"
        }
    }
}
