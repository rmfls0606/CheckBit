//
//  Double+Extension.swift
//  CheckBit
//
//  Created by 이상민 on 3/7/25.
//

import Foundation

extension Double{
    //MARK: - 소수점 표기 방식: 소수점 이하 3자리에서 반올림하여 소수점 2자리까지 표시
    func formatted2fValue() -> String?{
        let roundedValue = (self * 1000).rounded() / 1000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let resultString = formatter.string(from: NSNumber(value: roundedValue))
            
        return resultString
    }
    
    //MARK: - 소수점 표기 방식: 소수점 이하 3자리에서 반올림하여 소수점 2자리까지 표시 후 소수점 2자리가 0인 경우 1자리 까지만 표시
    func formatted1fValue() -> String?{
        let roundedValue = (self * 1000).rounded() / 1000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        let resultString = formatter.string(from: NSNumber(value: roundedValue))
            
        return resultString
    }
    
    //MARK: - 금액이 100만을 초과할 경우 백만 단위로 변환해 보여줍니다.
    func formattedMillionValue() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        if self >= 1_000_000 {
            let millionValue = self / 1_000_000
            let resultString = formatter.string(
                from: NSNumber(value: millionValue)
            ) ?? "\(millionValue)"
            return resultString + "백만"
        }else{
            return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        }
    }
}
