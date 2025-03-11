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
        let likeButtonTap: ControlEvent<Void>
    }
    
    struct Output{
        let price_in_7d_list: PublishRelay<[CoinDetail]>
        let isLiked: BehaviorRelay<Bool>
    }
    
    private let disposeBag = DisposeBag()
    private let repository = LikeTableRepository()
    
    func transform(input: Input) -> Output{
        let price_in_7d_list = PublishRelay<[CoinDetail]>()
        let isLiked = BehaviorRelay<Bool>(value: false)
        
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
        
        input.likeButtonTap
            .withLatestFrom(input.coinIds)
            .subscribe(with: self) { owner, id in
                if let existData = owner.repository.fetchAllCase().first(where: { $0.id == id }){
                    owner.repository.deleteItem(data: existData)
                    isLiked.accept(false)
                }else{
                    owner.repository.createItem(id: id)
                    isLiked.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.coinIds
            .subscribe(with: self, onNext: { owner, id in
                let liked = owner.repository.fetchAllCase().contains(where: {$0.id == id})
                isLiked.accept(liked)
            })
            .disposed(by: disposeBag)
        
        return Output(price_in_7d_list: price_in_7d_list, isLiked: isLiked)
    }
}
