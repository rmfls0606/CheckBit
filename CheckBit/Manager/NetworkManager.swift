//
//  NetworkManager.swift
//  CheckBit
//
//  Created by 이상민 on 3/8/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkManager{
    static let shared = NetworkManager()
    
    private init(){ }
    
    func callBackUpbitWithSingle<T: Decodable>(api: NetworkRequest) -> Single<Result<T, Error>>{
        
        return Single<Result<T, Error>>.create{ value in
            
            var components = URLComponents(url: api.endPoint, resolvingAgainstBaseURL: false)!
            components.queryItems = api.parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            
            guard let url = components.url else{
                value(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url){ data, response, error in
                
                if error != nil{
                    value(.failure(NetworkError.unknownResponse))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    value(.failure(NetworkError.unknownResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let messageData = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    value(.failure(NetworkError.statusError(statusCode: httpResponse.statusCode, message: messageData)))
                    return
                }
                
                if let data = data{
                    do{
                        let result = try JSONDecoder().decode(T.self, from:  data)
                        value(.success(.success(result)))
                    }catch(_){
                        value(.failure(NetworkError.unknownResponse))
                    }
                }else{
                    value(.failure(NetworkError.unknownResponse))
                }
            }
            .resume()
            
            return Disposables.create()
        }
    }
}
