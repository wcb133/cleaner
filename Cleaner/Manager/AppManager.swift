//
//  AppManager.swift
//  Cleaner
//
//  Created by fst on 2021/4/8.
//

import UIKit

class AppManager: NSObject {
    static let shared: AppManager = {
        let instance = AppManager()
        return instance
    }()
    
    //是否展示试用期
    var isShowTry = true
}
