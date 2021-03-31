//
//  BKOrderModel.swift
//  BankeBus
//
//  Created by jemi on 2020/12/3.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit

class BKOrderModel: BaseModel {
    ///订单id
    var id = 0
    ///订单号
    var orderNo = ""
    ///租赁时间
    var rent = RentModel()
    ///每月租金
    var rentAmount = 0.0
    ///总期数
    var period = 0
    ///订单状态 待处理=0,已拒绝=1,已接受=2,已完成=3
    var status = 0
    ///订单状态名
    var statusName = ""
    ///确认时间
    var confirmTime = ""
    ///支付方式
    var payType = 0
    ///支付方式名
    var payTypeName = ""
    ///结算日期
    var settlementDay = 0
    ///时间
    var auditValue = AuditValueModle()
    
    var businessCompany = BusinessCompanyModel()
    ///订单期数
    var carOwnerOrderPeriods:[CarOrderPeriodsModel] = []
    ///车
    var car = CarModel()
    ///是否可代开
    var canBillingAgent = true
    
    
    /// 获取订单列表
    class func getOrderData(dic:[String:Any],complete:@escaping ([BKOrderModel]) ->Void) {}
    
    
    /// 根据订单Id获取分期详情
    class func getCarOwnerOrderPeriodsData(_ orderId:Int,_ canBillingAgent:Bool,complete:@escaping ([CarOrderPeriodsModel]) ->Void) {}
    
    
    /// 获取订单详情
    class func getOrderDetailData(_ orderId:Int,complete:@escaping (BKOrderModel) ->Void) {}
    
    
    ///修改订单状态
    class func updateOrderData(_ parame:[String:Any],complete:@escaping (Bool) ->Void) {}
    
    
    /// 获取待开票分期数
    class func getcheepNumData(complete:@escaping (Int) ->Void) {}
    
}

class RentModel: BaseModel {
    ///开始时间
    var startTime = ""
    ///截止时间
    var endTime = ""
}

class AuditValueModle: BaseModel {
    ///创建时间
    var creationTime = ""
    ///更新时间
    var lastModificationTime = ""
}


class CarModel: BaseModel {
    ///id
    var id = 0
    ///车信息
    var carValue = CarValueModel()
}

class BusinessCompanyModel: BaseModel {
    var cityValue = CityValueModel()
    var businessCompanyValue = BusinessCompanyValue()
}

class BusinessCompanyValue: BaseModel {
    var address = ""
    var chargerName = ""
    var chargerPhone = ""
    var name = ""
    var receivingAddress = ""
    var taxIdNumber = ""
}

class CityValueModel: BaseModel {
    var province = ""
    var city = ""
}

class CarValueModel: BaseModel {
    ///车牌号
    var carNo = ""
    ///Logo
    var carLogo = ""
    ///车辆品牌
    var carBrand = ""
    ///车型
    var carShape = ""
    ///车型款式
    var carStyle = ""
}

class CarOrderPeriodsModel: BaseModel {
    ///
    var id = 0
    ///期数
    var period = 0
    ///订单Id
    var carOrderId = 0
    ///付款金额
    var amount = 0.0
    ///付款月份
    var payMonth = ""
    ///付款日期
    var settlementDate = ""
    ///是否已付款
    var isPaid = false
    ///
    var auditValue = AuditValueModle()
    ///所得税
    var tax = 0.0
    ///增值税
    var valueAddedAmount = 0.0
    ///附增税
    var additionalAmount = 0.0
    ///开票金额
    var totalAmount = 0.0
}
