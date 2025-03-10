//
//  CoinInformationViewModel.swift
//  CheckBit
//
//  Created by 이상민 on 3/10/25.
//

import Foundation
import RxSwift
import RxCocoa

final class CoinInformationViewModel {

    private let disposeBag = DisposeBag()

    struct Input{
    
    }
    
    struct Output{
        let trendingList: PublishRelay<[TrendingCoinItem]>
    }
    
    func transform(input: Input) -> Output{
        let trendingList = PublishRelay<[TrendingCoinItem]>()
        
        Observable<Int>.interval(.seconds(600), scheduler: MainScheduler.instance)
            .startWith(0)
            .flatMap{ _ in
                NetworkManager.shared.callBackUpbitWithSingle(api: CoingeckoRequest.trending)
                    .flatMap { (result: Result<TrendingCoins, Error>) -> Single<[TrendingCoinItem]> in
                        switch result {
                        case .success(let data):
                            return Single.just(data.coins)
                        case .failure(_):
                            return Single.just([])
                        }
                    }
            }
            .subscribe { value in
                trendingList.accept(value.element!)
            }
            .disposed(by: disposeBag)
        
        return Output(trendingList: trendingList)
    }
}

