//
//  Globa.swift
//  covid
//
//  Created by 김현인 on 2020/10/12.
//

import Foundation

class Global {
    // 싱글톤
    var shared = Global()
    private init() {}
    
    private static let today = Date()
    static var todayArray : Array = [Date]()
    
    public static func getTodayDate(decrease: Int = 7) {
        var tempDate = today
        for _ in 0..<decrease {
            tempDate = Calendar.current.date(byAdding: .day, value: -1, to: tempDate)!
            todayArray.append(tempDate)
        }
    }
}
