//
//  SubscribeVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/25.
//

import UIKit
import QMUIKit

class SubscribeVC: BaseVC {
    
    @IBOutlet weak var restoreBtn: QMUIButton!
    
    
    @IBOutlet weak var weekBTn: UIButton!
    
    @IBOutlet weak var monthBtn: UIButton!
    
    @IBOutlet weak var quarterBtn: UIButton!
    
    
    @IBOutlet weak var subscribeBtn: QMUIButton!

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topInsetCons: NSLayoutConstraint!
    
    @IBOutlet weak var topViewHeightCons: NSLayoutConstraint!
    
    //成功订阅block
    var successBlock:()->Void = { }
    
    var selectBtn:UIButton?
    var productID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectBtn = weekBTn
        productID = subscribeItems[0]
        self.view.backgroundColor = HEX("28B3FF")
        
        weekBTn.layer.cornerRadius = 25
        weekBTn.layer.masksToBounds = true
        monthBtn.layer.cornerRadius = 25
        monthBtn.layer.masksToBounds = true
        quarterBtn.layer.cornerRadius = 25
        quarterBtn.layer.masksToBounds = true
        
        subscribeBtn.layer.cornerRadius = 30
        subscribeBtn.layer.masksToBounds = true
        
        self.topInsetCons.constant = iPhoneX ? 30 : 0
        self.topViewHeightCons.constant = iPhoneX ? 340 :280
        
        if PaymentTool.shared.productDict.isEmpty {
            PaymentTool.shared.requestProducts(productArray: subscribeItems)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.topView.cornerWith(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 20)
    }
    
    
    @IBAction func itemACtion(_ sender: UIButton) {
        selectBtn?.isSelected = false
        sender.isSelected = true
        selectBtn = sender
        productID = subscribeItems[sender.tag]
    }
    
    @IBAction func subscribeBtnAction(_ sender: QMUIButton) {
        PaymentTool.shared.buyProduct(productID: productID) { (isSuccess) in
            //订阅成功
            if isSuccess{
                self.dismiss(animated: true) {
                    self.successBlock()
                }
            }else{
                QMUITips.show(withText: "订阅失败")
            }
        }
    }
    
    
    @IBAction func closeBtnACtion(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreBtnAction(_ sender: QMUIButton) {
        PaymentTool.shared.restorePurchase { (isSuccess) in
            self.dismiss(animated: true) {
                self.successBlock()
            }
        }
    }
    
}
