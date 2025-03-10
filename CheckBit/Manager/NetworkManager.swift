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
                print("잘못된 URL 정보 입니다.")
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url){ data, response, error in
                
                if let error = error{
                    print("error 발생")
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else{
                    print("접근에 실패하였습니다.")
                    return
                }
                
                if let data = data{
                    do{
                        let result = try JSONDecoder().decode(T.self
                                                              , from:  data)
                        value(.success(.success(result)))
                    }catch(let error){
                        print(error.localizedDescription)
                        print("데이터를 디코딩하는데 실패하였습니다.")
                    }
                }else{
                    print("데이터가 존재하지 않습니다.")
                }
            }
            .resume()
            
            return Disposables.create()
        }
    }
}
