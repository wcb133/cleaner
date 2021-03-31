//
//  BKShopOrderDetailFootView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/31.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKShopOrderDetailFootView: UIView {
    
    //金额明细
    let moneyView = BKNeedPayMoneyInfoView.loadNib()
    //单号支付凭证
    let orderNumView = BKOrderNumInfoView.loadNib()
    //发票信息
    let billView = BKBillInfoView.loadNib()
    
    var model = BKShopOrderModel() {
        didSet{
            moneyView.isHidden = false
            orderNumView.isHidden = false
            moneyView.totalLabel.text = String(format: "%.2f", model.amount)
            moneyView.monLabel.text = String(format: "%.2f", model.freightAmount)
            moneyView.payLabel.text = String(format: "%.2f", model.amount + model.freightAmount)
            
            orderNumView.orderNoLabel.text = model.orderNo
            orderNumView.payTypeNumLabel.text = model.transactionId
            orderNumView.timeLabel.text = model.creationTime
            if model.payType > 0 && model.payType <= 20000 {
                orderNumView.paynameLabel.text = "微信交易号："
            }else if model.payType > 20000 && model.payType <= 40000{
                orderNumView.paynameLabel.text = "支付宝交易号："
            }else {
                orderNumView.paynameLabel.text = "零钱交易号："
            }
            
            
            if model.state == 1 || model.state == 9{
                moneyView.payName.text = "待付款"
                self.qmui_height = 97 + 12 + (model.hasInv ? 171+12 : 0)
                orderNumView.snp.updateConstraints { (m) in
                    m.top.equalTo(moneyView.snp_bottom).offset(0)
                    m.height.equalTo(0)
                }
            }else {
                self.qmui_height = 97+12+141+12 + (model.hasInv ? 171+12 : 0)
                moneyView.payName.text = "实付款"
                orderNumView.snp.updateConstraints { (m) in
                    m.top.equalTo(moneyView.snp_bottom).offset(12)
                    m.height.equalTo(141)
                }
            }
            
            billView.isHidden = !model.hasInv
            billView.model = model.invoiceModel
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    func loadUI() {
        addSubview(moneyView)
        moneyView.snp.makeConstraints { (m) in
            m.top.equalToSuperview()
            m.leading.equalTo(12)
//            m.width.equalTo(width-24)
            m.height.equalTo(97)
        }
        moneyView.isHidden = true
        
        addSubview(orderNumView)
        orderNumView.snp.makeConstraints { (m) in
            m.top.equalTo(moneyView.snp_bottom).offset(12)
            m.leading.equalTo(12)
//            m.width.equalTo(width-24)
            m.height.equalTo(141)
        }
        orderNumView.isHidden = true
        
        addSubview(billView)
        billView.snp.makeConstraints { (m) in
            m.top.equalTo(orderNumView.snp_bottom).offset(12)
            m.leading.equalTo(12)
//            m.width.equalTo(width-24)
            m.height.equalTo(171)
        }
        billView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
