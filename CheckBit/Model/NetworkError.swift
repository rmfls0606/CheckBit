//
//  NetworkError.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation

enum NetworkError: Error, LocalizedError{
    case invalidURL
    case unknownResponse
    case statusError(statusCode: Int, message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL 정보입니다."
        case .unknownResponse:
            return "유효하지 않은 데이터입니다."
        case .statusError(statusCode: let code, message: let msg):
            return "상태 코드 오류: \(code), \(msg)"
        }
    }
}
