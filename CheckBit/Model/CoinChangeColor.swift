//
//  CoinChangeColor.swift
//  CheckBit
//
//  Created by 이상민 on 3/9/25.
//

import UIKit

enum CoinChangeColor: String{
    case even = "EVEN"
    case rise = "RISE"
    case fall = "FALL"
    
    var textColor: UIColor {
        switch self {
        case .even:
            return UIColor(resource: .main)
        case .rise:
            return UIColor(resource: .risingPrice)
        case .fall:
            return UIColor(resource: .fallingPrice)
        }
    }
}
