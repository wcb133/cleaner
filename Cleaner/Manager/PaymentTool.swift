//
//  PaymentTool.swift
//  Cleaner
//
//  Created by fst on 2021/3/24.
//

import UIKit
import StoreKit

class PaymentTool: NSObject,SKPaymentTransactionObserver,SKProductsRequestDelegate {
    
    //是否已经支付
    var isDidPay = false

    static let shared: PaymentTool = {
        let instance = PaymentTool()
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
    
//    func payment(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
    
}

extension PaymentTool{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
    }
}
