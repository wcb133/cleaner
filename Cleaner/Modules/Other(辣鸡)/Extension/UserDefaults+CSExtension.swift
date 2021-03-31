//
//  UserDefaults+CSExtension.swift
//  CarStaff
//
//  Created by fst on 2020/3/26.
//  Copyright © 2020 fst. All rights reserved.
//

import UIKit

extension UserDefaults {
    // 用户信息
    struct UserInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
            case phone
            case avatarUrl
            case firstStart1
            case name
        }
    }
    
    // 登录信息
//    struct LoginInfo: UserDefaultsSettable {
//        enum defaultKeys: String {
//            case token
//            case userId
//        }
//    }
}

protocol UserDefaultsSettable {
    associatedtype defaultKeys: RawRepresentable
}
 
extension UserDefaultsSettable where defaultKeys.RawValue == String {
    static func set(value: Any?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    
    static func string(forKey key: defaultKeys) -> String? {
        let aKey = key.rawValue
        return UserDefaults.standard.string(forKey: aKey)
    }
    
    static func integer(forKey key: defaultKeys) -> Int {
        let aKey = key.rawValue
        return UserDefaults.standard.integer(forKey: aKey)
    }
    
    static func bool(forKey key: defaultKeys) -> Bool {
        let aKey = key.rawValue
        return UserDefaults.standard.bool(forKey: aKey)
    }
}
