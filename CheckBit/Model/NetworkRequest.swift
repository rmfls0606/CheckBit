//
//  NetworkRequest.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkRequest {
    var endPoint: URL { get }
    var parameters: [String: Any]{ get }
    var method: HTTPMethod { get }
}

extension NetworkRequest{
    var method: HTTPMethod{
        return .get
    }
}

enum UpbitRequest: NetworkRequest{
    case market
    
    var baseURL: String{
        return NetworkURL.upbitURL
    }
    
    var endPoint: URL{
        switch self {
        case .market:
            return URL(string: baseURL)!
        }
    }
    
    var parameters: [String : Any]{
        return ["quote_currencies":"KRW"]
    }
}

enum CoingeckoRequest: NetworkRequest{
    case trending
    case search(query: String)
    case coins(vs_currenct: String, ids: String)
    
    var baseURL: String{
        return NetworkURL.coinGeckoURL
    }
    
    var endPoint: URL{
        switch self{
        case .trending:
            return URL(string: baseURL + "/search/trending")!
        case .search:
            return URL(string: baseURL + "/search")!
        case .coins:
            return URL(string: baseURL + "/coins/markets")!
        }
    }
    
    var parameters: [String : Any]{
        switch self{
        case .trending:
            return [:]
        case .search(let query):
            return ["query": query]
        case .coins(let vs_currenct, let ids):
            return ["vs_currency": vs_currenct,
                    "ids": ids,
                    "sparkline": true]
        }
    }
}
