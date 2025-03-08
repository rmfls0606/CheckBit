//
//  TransactionViewModel.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TransactionViewModel {
    
    private let disposeBag = DisposeBag()

    struct Input{
        
    }
    
    struct Output{
        let coinList: PublishRelay<[MarketData]>
    }
    
    func transform(input: Input) -> Output{
        let coinList = PublishRelay<[MarketData]>()
        
        Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .startWith(0)
            .map{ print("return\($0)") }
            .flatMap { _ in
                NetworkManager.shared.callBackUpbitWithSingle()
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let marketData):
                    coinList.accept(marketData)
                case .failure(let error):
                    coinList.accept([])
                }
            })
            .disposed(by: disposeBag)
        
        return Output(coinList: coinList)
    }
}
