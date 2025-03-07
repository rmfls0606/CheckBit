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
}
