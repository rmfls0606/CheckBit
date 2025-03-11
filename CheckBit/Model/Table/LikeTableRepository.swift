//
//  LikeTableRepository.swift
//  CheckBit
//
//  Created by 이상민 on 3/11/25.
//

import Foundation
import RealmSwift

protocol RepositoryProtocol{
    func fetchAllCase() -> Results<LikeTable>
    func createItem(id: String)
    func deleteItem(data: LikeTable)
}

final class LikeTableRepository: RepositoryProtocol {
    private let realm = try! Realm()
    
    func fetchAllCase() -> Results<LikeTable> {
        let data = realm.objects(LikeTable.self)
        
        return data
    }
    
    func createItem(id: String) {
        do{
            try realm.write {
                let data = LikeTable(id: id)
                
                realm.add(data)
                print("램 저장 완료")
            }
        }catch{
            print("램에 저장이 실패한 경우")
        }
    }
    
    func deleteItem(data: LikeTable) {
        do{
            try realm.write {
                realm.delete(data)
            }
        }catch{
            print("램 데이터 삭제 실행")
        }
    }
}
