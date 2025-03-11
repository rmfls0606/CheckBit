//
//  CoinDetailViewModel.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation
import RxSwift
import RxCocoa

class CoinDetailViewModel{
    
    struct Input{
        let coinIds: Observable<String>
    }
    
    struct Output{
        let price_in_7d_list: PublishRelay<[CoinDetail]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output{
        let price_in_7d_list = PublishRelay<[CoinDetail]>()
        
        Observable<Int>.interval(.seconds(60), scheduler: MainScheduler.instance)
            .startWith(0)
            .flatMapLatest { _ in input.coinIds }
            .flatMap { ids -> Single<[CoinDetail]> in
                NetworkManager.shared
                    .callBackUpbitWithSingle(api: CoingeckoRequest.coins(vs_currenct: "KRW", ids: ids))
                    .flatMap { (
                        result: Result<[CoinDetail],
                        Error>
                    ) -> Single<[CoinDetail]> in
                        switch result{
                        case .success(let data):
                            return Single.just(data)
                        case .failure(_):
                            return Single.just([])
                        }
                    }
            }
            .observe(on: MainScheduler.instance)
            .subscribe { value in
                price_in_7d_list.accept(value)
            }
            .disposed(by: disposeBag)
        
        return Output(price_in_7d_list: price_in_7d_list)
    }
}
