//
//  Data.swift
//  covid
//
//  Created by 김현인 on 2020/10/17.
//

import Foundation

final class DataGetSet {
    private init() {}
    static let shared = DataGetSet()
    var covidDeathArray:[Int] = []
    
    public var covidDeath: Int {
        get {
            return defaultForKey(key: "deathCnt")
        } set(value) {
            self.covidDeathArray.append(value)
        }
    }
    
    private func setDefault(key: String, value: Any) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func defaultForKey(key: String) -> Int {
        return UserDefaults.standard.integer(forKey:key)
    }
}
