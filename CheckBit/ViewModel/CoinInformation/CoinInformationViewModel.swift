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
        let textFieldButtonTap: ControlEvent<Void> //엔터키
        let textFieldText: ControlProperty<String> //입력값
    }
    
    struct Output{
        let trendingList: PublishRelay<[TrendingCoinItem]>
        let nftList: PublishRelay<[TrendingNFTItem]>
        let dateString: BehaviorRelay<String>
        let searchResut: PublishRelay<String>
    }
    
    func transform(input: Input) -> Output{
        let trendingList = PublishRelay<[TrendingCoinItem]>()
        let nftList = PublishRelay<[TrendingNFTItem]>()
        let dateString = BehaviorRelay(value: "")
        let searchResult = PublishRelay<String>()
        
        let timer = Observable<Int>.interval(.seconds(600), scheduler: MainScheduler.instance)
            .startWith(0)
            .share(replay: 1)
        
        timer
            .flatMap{ _ in
                NetworkManager.shared.callBackUpbitWithSingle(api: CoingeckoRequest.trending)
                    .flatMap { (result: Result<TrendingCoinNFTItems, Error>) -> Single<([TrendingCoinItem], [TrendingNFTItem])> in
                        switch result {
                        case .success(let data):
                            return Single.just((data.coins, data.nfts))
                        case .failure(_):
                            return Single.just(([],[]))
                        }
                    }
            }
            .subscribe { value in
                trendingList.accept(value.element!.0)
                nftList.accept(value.element!.1)
            }
            .disposed(by: disposeBag)
        
        timer
            .map { _ -> String in
                let formatter = DateFormatter()
                formatter.dateFormat = "MM.dd HH:mm 기준"
                return formatter.string(from: Date())
            }
            .subscribe(onNext: { value in
                dateString.accept(value)
            })
            .disposed(by: disposeBag)
        
        input.textFieldButtonTap
            .withLatestFrom(input.textFieldText){ _, text in
                text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            .filter{ !$0.isEmpty}
            .subscribe(onNext: { text in
                searchResult.accept(text)
            })
            .disposed(by: disposeBag)
        
        return Output(trendingList: trendingList, nftList: nftList, dateString: dateString, searchResut: searchResult)
    }
}

