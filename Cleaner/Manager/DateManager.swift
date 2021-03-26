//
//  DateManager.swift
//  Cleaner
//
//  Created by fst on 2021/3/25.
//

import UIKit

private let TimeKey = "TimeKey"
class DateManager: NSObject {
    
    static let shared: DateManager = {
        let instance = DateManager()
        return instance
    }()
   
    //获取有效期
    func getValidTime() -> TimeInterval {
        let value:Double = UserDefaults.standard.object(forKey: TimeKey) as? Double ?? 0
        return value
    }
    
    //保存有效期
    func saveValidTime(validTime:Int64)  {
        let time = Double(validTime) * 0.001
        UserDefaults.standard.set(time, forKey: TimeKey)
        UserDefaults.standard.synchronize()
    }
    
    //订阅是否过期
    func isExpired() -> Bool {
        let currentDate = Date()
        let interval1970 = currentDate.timeIntervalSince1970
        let validTime = getValidTime()
        return interval1970 > validTime ? true:false
    }
    
    func addWeek()  {
        let isExpired = self.isExpired()
        if isExpired {
            let currentDate = Date()
            let interval = currentDate.timeIntervalSince1970 + 7 * 24 * 3600
            UserDefaults.standard.set(interval, forKey: TimeKey)
            UserDefaults.standard.synchronize()
        }else{
            let interval = self.getValidTime() + 7 * 24 * 3600
            UserDefaults.standard.set(interval, forKey: TimeKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func addMonth()  {
        let isExpired = self.isExpired()
        if isExpired {
            let currentDate = Date()
            let interval = currentDate.timeIntervalSince1970 + 30 * 24 * 60 * 60
            UserDefaults.standard.set(interval, forKey: TimeKey)
            UserDefaults.standard.synchronize()
        }else{
            let interval = self.getValidTime() + 30 * 24 * 3600
            UserDefaults.standard.set(interval, forKey: TimeKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func addQuarter()  {
        let isExpired = self.isExpired()
        if isExpired {
            let currentDate = Date()
            let interval = currentDate.timeIntervalSince1970 + 3 * 30 * 24 * 60 * 60
            UserDefaults.standard.set(interval, forKey: TimeKey)
            UserDefaults.standard.synchronize()
        }else{
            let interval = self.getValidTime() + 3 * 30 * 24 * 3600
            UserDefaults.standard.set(interval, forKey: TimeKey)
            UserDefaults.standard.synchronize()
        }
    }

}
