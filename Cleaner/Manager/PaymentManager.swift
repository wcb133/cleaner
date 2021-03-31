//
//  PaymentTool.swift
//  Cleaner
//
//  Created by fst on 2021/3/24.
//

import UIKit
import StoreKit
import QMUIKit


class PaymentManager: NSObject,SKPaymentTransactionObserver,SKProductsRequestDelegate {
    
    //是否向苹果服务器验证
    var checkAfterPay = false
    
    //购买结果回调
    var completeBlock:(Bool)->Void = {_ in}
    
    //所有商品
    var productDict:[String:SKProduct] = [:]
    
    private var isSandbox = true

    static let shared: PaymentManager = {
        let instance = PaymentManager()
        return instance
    }()
    
    //添加监听
    func addObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func requestProducts(productArray:[String]) {
        // 能够销售的商品
        let set = Set(productArray)
        // "异步"询问苹果能否销售
        let request = SKProductsRequest(productIdentifiers: set)
        request.delegate = self
        request.start()
    }
    
    
    //购买产品
    func buyProduct(productID:String,completeBlock:@escaping (Bool)->Void)  {
        QMUITips.showLoading(in: cKeyWindow!)
        self.completeBlock = completeBlock
        if let product = self.productDict[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }else{
            QMUITips.hideAllTips()
            self.completeBlock(false)
            QMUITips.show(withText: "暂无对应商品")
            if self.productDict.isEmpty {
                self.requestProducts(productArray: subscribeItems)
            }
        }
    }
    
    //恢复购买
    func restorePurchase(completeBlock:@escaping (Bool)->Void) {
        self.completeBlock = completeBlock
        QMUITips.showLoading(in: cKeyWindow!)
        //恢复已经完成的所有交易.（仅限永久有效商品）
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            QMUITips.hideAllTips()
        }
    }
    
    //向苹果服务器验证 验证购买凭据
    private func verifyPruchase(productID:String) {
        
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
        // 从沙盒中获取到购买凭据
        guard let receiptData = try? Data(contentsOf: receiptURL) else { return }
        let receiptString = receiptData.base64EncodedString()
        
        let url = self.isSandbox ? "https://sandbox.itunes.apple.com/verifyReceipt" :"https://buy.itunes.apple.com/verifyReceipt"
        let paramer:[String:Any] = ["receipt-data":receiptString,"password": "ef56ea9f46024b5194ad9ee8494e41ac"]
        QMUITips.showLoading(in: cKeyWindow!)
        Network.request(target: HRService(url: url, paramer: paramer, requesMethod: .post)) { (response) in
            QMUITips.hideAllTips()
            guard let responseDict = response as? [String:Any] else { return }
            guard let status = responseDict["status"] as? Int else { return }
            if status == 0 {//验证成功
                //更新过期时间
                let latestReceiptInfos:[[String:Any]] = responseDict["latest_receipt_info"] as? [[String:Any]] ?? []
                if let latestReceiptInfo = latestReceiptInfos.first{
                    let time = latestReceiptInfo["expires_date_ms"] as? Int64 ?? 0
                    DateTool.shared.saveValidTime(validTime: time)
                }
                
                self.completeBlock(true)
            }else if status == 21007 {//验证发送到了测试环境
                self.isSandbox = true
                self.verifyPruchase(productID: productID)
            } else if status == 21008 {//验证发送到了正式环境
                self.isSandbox = false
                self.verifyPruchase(productID: productID)
            }else{//验证失败
                QMUITips.show(withText: "购买失败")
                self.completeBlock(false)
            }
                 
        } failure: { (moyaError) in
            QMUITips.hideAllTips()
            QMUITips.show(withText: "网络不佳，稍后再试")
            self.completeBlock(false)
        }
    }
    
}

extension PaymentManager{
    //购买队列状态变化,判断购买状态是否成功
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased://购买成功，已经订阅再次订阅，都走这里
                QMUITips.hideAllTips()
                if let original = transaction.original {//自动续订
                    
                }
                if checkAfterPay {//做校验
                    verifyPruchase(productID: transaction.payment.productIdentifier)
                }else{//不验证
                    let productID = transaction.payment.productIdentifier
                    if productID == subscribeItems[0] {
                        DateTool.shared.addWeek()
                    }else if productID == subscribeItems[1] {
                        DateTool.shared.addMonth()
                    }else if productID == subscribeItems[2]{
                        DateTool.shared.addQuarter()
                    }
                    self.completeBlock(true)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored://恢复购买
                QMUITips.hideAllTips()
                QMUITips.show(withText: "已恢复订阅")
                print("恢复购买")
                let productID = transaction.payment.productIdentifier
                SKPaymentQueue.default().finishTransaction(transaction)
                if DateTool.shared.isExpired() {
                    if productID == subscribeItems[0] {
                        DateTool.shared.addWeek()
                    }else if productID == subscribeItems[1] {
                        DateTool.shared.addMonth()
                    }else if productID == subscribeItems[2]{
                        DateTool.shared.addQuarter()
                    }
                    self.completeBlock(true)
                    print("======恢复购买")
                }
            case .failed://购买失败
                QMUITips.hideAllTips()
                print("购买失败，稍后再试")
                self.completeBlock(false)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing://正在购买
                break
            default://已经购买
                QMUITips.hideAllTips()
                self.completeBlock(false)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            self.productDict[product.productIdentifier] = product
        }
    }
}
