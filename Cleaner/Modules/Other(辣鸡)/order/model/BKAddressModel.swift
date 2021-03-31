//
//  BKAddressModel.swift
//  BankeBus
//
//  Created by jemi on 2020/12/3.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit

class BKAddressModel: BaseModel {
    var text = ""
    var value = ""
    
    /// 获取省份
    class func getProvinceData(complete:@escaping ([BKAddressModel]) ->Void) {
    }
    
    /// 获取城市
    class func getCityData(_ province:String,complete:@escaping ([BKAddressModel]) ->Void) {

    }
    
    /// 获取市区
    class func getCountyData(_ city:String,complete:@escaping ([BKAddressModel]) ->Void) {}
    
}
