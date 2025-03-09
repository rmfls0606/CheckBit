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
        let currentPriceTap: ControlEvent<Void>
        let comparePreDatTap: ControlEvent<Void>
        let tradePriceTap: ControlEvent<Void>
    }
    
    struct Output{
        let coinList: PublishRelay<[MarketData]>
    }
    
    func transform(input: Input) -> Output{
        let coinList = PublishRelay<[MarketData]>()
        let sortRelay = BehaviorRelay<SortItem>(value: .tradePrice(.none))
        
        input.currentPriceTap
            .subscribe(with: self) { owner, _ in
                if case SortItem.currentPrice(let option) = sortRelay.value{
                    let newSortItem: SortItem = (option == .desc) ? .currentPrice(.asc) : ((option == .asc) ? .currentPrice(.none): .currentPrice(.desc))
                    sortRelay.accept(newSortItem)
                }else{
                    sortRelay.accept(.currentPrice(.desc))
                }
            }
            .disposed(by: disposeBag)
        
        input.comparePreDatTap
            .subscribe(with: self) { owner, value in
                if case SortItem.comaprePreDay(let option) = sortRelay.value{
                    let newSortItem: SortItem = (option == .desc) ? .comaprePreDay(.asc) : ((option == .asc) ? .comaprePreDay(.none): .comaprePreDay(.desc))
                    sortRelay.accept(newSortItem)
                } else {
                    sortRelay.accept(.comaprePreDay(.desc))
                }
            }
            .disposed(by: disposeBag)
        
        input.tradePriceTap
            .subscribe(with: self) { owner, value in
                if case SortItem.tradePrice(let option) = sortRelay.value{
                    let newSortItem: SortItem = (option == .desc) ? .tradePrice(.asc) : ((option == .asc) ? .tradePrice(.none): .tradePrice(.desc))
                    sortRelay.accept(newSortItem)
                } else {
                    sortRelay.accept(.tradePrice(.desc))
                }
            }
            .disposed(by: disposeBag)
        
        let networkData = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .startWith(0)
            .flatMap { _ in
                NetworkManager.shared.callBackUpbitWithSingle()
                    .flatMap { result -> Single<[MarketData]> in
                        switch result {
                        case .success(let data):
                            return Single.just(data)
                        case .failure(_):
                            return Single.just([])
                        }
                    }
            }
        
        Observable.combineLatest(networkData, sortRelay) { data, sortOption -> [MarketData] in
            return sortOption.sortCoinList(data)
        }
        .subscribe(onNext: { sortedData in
            coinList.accept(sortedData)
        })
        .disposed(by: disposeBag)
        
        return Output(coinList: coinList)
    }
}
