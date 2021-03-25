//
//  PaymentTool.swift
//  Cleaner
//
//  Created by fst on 2021/3/24.
//

import UIKit
import StoreKit
import QMUIKit


class PaymentTool: NSObject,SKPaymentTransactionObserver,SKProductsRequestDelegate {
    
    //是否已经支付
//    var isDidPay = false
    //是否向苹果服务器验证
    var checkAfterPay = true
    
    //购买结果回调
    var completeBlock:(Bool)->Void = {_ in}
    
    //所有商品
    var productDict:[String:SKProduct] = [:]
    
    private var isSandbox = true

    static let shared: PaymentTool = {
        let instance = PaymentTool()
        return instance
    }()
    
    //添加监听
    func addObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    func requestProducts(productArray:[String]) {
        QMUITips.showLoading(in: cKeyWindow!)
        // 能够销售的商品
        let set = Set(productArray)
        // "异步"询问苹果能否销售
        let request = SKProductsRequest(productIdentifiers: set)
        request.delegate = self
        request.start()
    }
    
    
    //购买产品
    func buyProduct(productID:String,completeBlock:@escaping (Bool)->Void)  {
        self.completeBlock = completeBlock
        if let product = self.productDict[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }else{
            self.completeBlock(false)
            QMUITips.show(withText: "暂无对应商品")
        }
    }
    
    //恢复购买
    func restorePurchase() {
        //恢复已经完成的所有交易.（仅限永久有效商品）
        SKPaymentQueue.default().restoreCompletedTransactions()
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
        HRNetwork.request(target: HRService(url: url, paramer: paramer, requesMethod: .post)) { (response) in
            QMUITips.hideAllTips()
            guard let responseDict = response as? [String:Any] else { return }
            guard let status = responseDict["status"] as? Int else { return }
            if status == 0 {//验证成功
                self.completeBlock(true)
            }else if status == 21007 {//沙箱测试返回结果
                self.isSandbox = true
                self.verifyPruchase(productID: productID)
            } else if status == 21008 {//正式环境返回结果,再次请求验证
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

extension PaymentTool{
    //购买队列状态变化,,判断购买状态是否成功
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased://购买成功，已经订阅再次订阅，都走这里
                QMUITips.hideAllTips()
                if let original = transaction.original {//自动续订
                    
                }
                if checkAfterPay {
                    verifyPruchase(productID: transaction.payment.productIdentifier)
                }else{
                    self.completeBlock(true)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored://恢复购买
                QMUITips.hideAllTips()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed://购买失败
                QMUITips.hideAllTips()
                self.completeBlock(false)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                break
            default://已经购买
                QMUITips.hideAllTips()
                self.completeBlock(true)
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
