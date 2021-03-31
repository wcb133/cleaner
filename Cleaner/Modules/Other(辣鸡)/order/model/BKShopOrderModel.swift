//
//  BKShopOrderModel.swift
//  BankeBus
//
//  Created by jemi on 2021/1/11.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKShopOrderModel: BaseModel {
    ///订单Id
    var orderId = 0
    ///订单号
    var orderNo = ""
    ///未知=0,未支付=1,已支付=2,已发货=3,已经签收=4,部分退款=5,已退款=7,已取消=9,完成=100,删除=1000
    var state = 0
    var stateName = ""
    ///订单商品（一般子单1商品，主单可能多商品）
    var goodsList:[BKGoodsModel] = []
    
    var consignee = ""
    var mobile = ""
    var address = ""
    
    //以下属性详情接口才有
    ///订单关闭时间（未支付状态下才有值.格式：2021-01-05 09:05:56）
    var closeOrderTime = ""
    ///支付编号(第三方)
    var transactionId = ""
    ///商品总金额
    var amount = 0.0
    ///支付金额
    var payAmount = 0.0
    ///运费
    var freightAmount = 0.0
    ///是否开发票
    var hasInv = false
    ///下单时间
    var creationTime = ""
    ///发票信息模型
    var invoiceModel = BKInvoiceModel()
    ///订单收货地址信息模型
    var addressModel = BKReceAddressModel()
    ///订单物流信息模型
    var logisticsModel = BKOrderLogisticsModel()
    ///订单发货之后确认收货时间（发货状态下才有值.格式：2021-01-05 09:05:56）
    var orderReceivingTime = ""
    ///未知=0,车生活APP微信支付=1,微信APP支付=1000,微信JSAPI 支付=2000,微信小程序支付=3000,微信h5支付=4000,微信支付边界=20000, 车生活APP支付宝支付=20001, 支付宝APP支付=21000,支付宝手机网站支付=22000,支付宝支付=40000,车生活支付=100000
    var payType = 0
    var payTypeName = ""
    
    /// 获取订单列表
    class func getShopOrderData(dic:[String:Any],complete:@escaping ([BKShopOrderModel]) ->Void) {}
    
    
    /// 获取订单详情
    class func getOrderDetailData(_ orderNo:String,complete:@escaping (BKShopOrderModel) ->Void) {}
    
    
}

class BKGoodsModel: BaseModel {
    ///商品Id
    var goodsId = 0
    ///商品名称
    var goodsName = ""
    ///sku
    var sku = ""
    ///价格
    var goodsPrice = 0.0
    ///数量
    var goodsNumber = 0
    ///商品图
    var goodsImageUrl = ""
}

class BKInvoiceModel: BaseModel {
    ///未知=0,电子普通发票=1,商业发票=2
    var invType = 0
    ///未知=0,电子普通发票=1,商业发票=2
    var invTypeName = ""
    ///未知=0,个人=1,企业=2
    var invPayeeType = 1
    ///未知=0,个人=1,企业=2
    var invPayeeTypeName = ""
    ///发票-抬头
    var invPayee = ""
    ///发票-内容
    var invcontent = ""
    ///发票-收件人
    var invConsignee = ""
    ///发票-邮箱
    var invEmail = ""
    ///发票-纳税人识别号
    var invITIN = ""
    
    ///是否需要发票
    var isInv = false
}

class BKReceAddressModel: BaseModel {
    ///收件人
    var consignee = ""
    ///收件人电话
    var mobile = ""
    ///邮编
    var zipcode = ""
    ///地址
    var address = ""
}



class BKOrderStatusNumModel: BaseModel {
    
    ///未知=0,未支付=1,已支付=2,已发货=3,已经签收=4,部分退款=5,已退款=7,部分取消=8,已取消=9,完成=100,删除=1000
    var orderState = 0
    ///数量
    var num = 0
    
    //支付
    var prepayId = ""
    //未知=0,车生活APP微信支付=1,微信APP支付=1000,微信JSAPI 支付=2000,微信小程序支付=3000,微信h5支付=4000,微信支付边界=20000, 车生活APP支付宝支付=20001, 支付宝APP支付=21000,支付宝手机网站支付=22000,支付宝支付=40000,车生活支付=100000
    var payType = 0
    var orderNo = ""
    //是否支付成功（只有在使用余额支付或者支付金额0的时候才会返回true）
    var paySuccess = false
    
    
    /// 订单各状态数量显示
    class func getStatusNumData(dic:[String:Any],complete:@escaping ([BKOrderStatusNumModel]) ->Void) {}
    
    
    /// 订单app支付【客户端：APP】
    class func getOrderPayData(_ parame:[String:Any],complete:@escaping (BKOrderStatusNumModel) ->Void) {}
    
    
    ///关闭订单
    class func closeOrderData(_ orderNo:String,complete:@escaping (Bool) ->Void) {}
    
    
    ///删除订单（取消的订单可以删除）
    class func removeOrderData(_ orderNo:String,complete:@escaping (Bool) ->Void) {}
    
    
    ///确认收货
    class func recieveOrderData(_ orderNo:String,complete:@escaping (Bool) ->Void) {}
    
    
    ///添加商品评论
    class func addOrderCommentData(_ parame:[String:Any],complete:@escaping (Bool) ->Void) {}
    
}


class GoodsOrderModel: BaseModel {
    var goodsId = 0
    var number = 0
    var templateId = 0
    var attributes:[AttModel] = []
    var goodsImageUrl = ""
    var goodsName = ""
    var goodsPrice = 0.0
    
    /// 从订单获取商品信息
    class func getShopOrderGoodsData(_ orderNo:String,complete:@escaping ([GoodsOrderModel]) ->Void) {}
    
}

class AttModel: BaseModel {
    var name = ""
    var value = ""
}
