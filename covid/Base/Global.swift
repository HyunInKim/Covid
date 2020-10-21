//
//  Globa.swift
//  covid
//
//  Created by 김현인 on 2020/10/12.
//

import Foundation
import SystemConfiguration

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
class Global {
    // 싱글톤
    static let shared: Global = Global()
    private init() {}
    
    private let today = Date()
    
    var todayArrays: [Date] {
        get {
            return getTodayDate()
        }
    }
    
    var networkStatus: Bool {
        get {
            return checkDeviceNetworkStatus()
        }
    }
    
    private func getTodayDate(decrease: Int = 30) -> [Date]{
        var tempDate = today
        var todayArray : Array = [Date]()
        for _ in 0..<decrease {
            tempDate = Calendar.current.date(byAdding: .day, value: -1, to: tempDate)!
            todayArray.append(tempDate)
        }
        return todayArray
    }
    
    private func checkDeviceNetworkStatus() -> Bool {
        print("Check to Device Natwork Status....")
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
