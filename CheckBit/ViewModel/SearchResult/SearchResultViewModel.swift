//
//  SearchResultViewModel.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input{
        let searchText: ControlProperty<String>
        let searchTap: ControlEvent<Void>
    }
    
    struct Output{
        let searchResult: PublishRelay<[SearchCoin]>
    }
    
    func transform(input: Input) -> Output{
        let searchResult = PublishRelay<[SearchCoin]>()
        let searchQuery = BehaviorRelay<String>(value: "")
        
        input.searchText
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter{ !$0.isEmpty }
            .bind(to: searchQuery)
            .disposed(by: disposeBag)
        
        let searchClicked = input.searchTap
            .withLatestFrom(input.searchText)
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter{ !$0.isEmpty }
            .distinctUntilChanged()
        
        let timer = Observable<Int>.interval(.seconds(900), scheduler: MainScheduler.instance)
            .startWith(0)
            .withLatestFrom(searchQuery)
            .filter{ !$0.isEmpty }
        
        Observable.merge(searchClicked, timer)
            .flatMap { currentQuery -> Single<[SearchCoin]> in
                return NetworkManager.shared.callBackUpbitWithSingle(api: CoingeckoRequest.search(query: currentQuery))
                    .flatMap { (result: Result<SearchData, Error>) -> Single<[SearchCoin]> in
                        switch result {
                        case .success(let data):
                            return Single.just(data.coins)
                        case .failure(let error):
                            print("검색 API 에러: \(error.localizedDescription)")
                            return Single.just([])
                        }
                    }
            }
            .subscribe(onNext:{ value in
                searchResult.accept(value)
            })
            .disposed(by: disposeBag)
        
        return Output(searchResult: searchResult)
    }
}
