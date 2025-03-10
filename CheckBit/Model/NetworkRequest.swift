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
    
    var method: HTTPMethod{
        return .get
    }
}
