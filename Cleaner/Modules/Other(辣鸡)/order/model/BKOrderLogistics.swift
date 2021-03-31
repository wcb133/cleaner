//
//  BKOrderLogistics.swift
//  BankeBus
//
//  Created by jemi on 2021/1/15.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKOrderLogisticsModel: BaseModel {
    ///状态: 0=在途，1=揽收，2=疑难，3=签收，4=退签，5=派件，6=退回
    var logisticsState = 0
    ///物流单号
    var logisticsNo = ""
    ///物流商家
    var logisticsBusiness = ""
    ///是否确认签收
    var isFinish = false
    ///物流信息
    var logisticsList:[BKLogisticsModel] = []
    
    /// 获取订单物流
    class func getOrderLogisticsData(_ orderNo:String,complete:@escaping (BKOrderLogisticsModel) ->Void) {}
    
}

class BKLogisticsModel: BaseModel {
    ///时间线
    var timeLine = ""
    ///物流状态图标
    var icon = ""
    ///状态: 0=在途，1=揽收，2=疑难，3=签收，4=退签，5=派件，6=退回
    var state = 0
    ///物流内容
    var context = ""
    ///状态描述
    var statusDesc = ""
    
    var isFirst = false
}
