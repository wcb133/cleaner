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
    
    
    var selectBtn:UIButton?
    var producetID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectBtn = weekBTn
        producetID = subscribeItems[0]
        self.view.backgroundColor = HEX("28B3FF")
    }
    
    
    @IBAction func itemACtion(_ sender: UIButton) {
        selectBtn?.isSelected = false
        sender.isSelected = true
        selectBtn = sender
        producetID = subscribeItems[sender.tag]
    }
    
    @IBAction func subscribeBtnAction(_ sender: QMUIButton) {
        PaymentTool.shared.buyProduct(productID: producetID) { (isSuccess) in
            if isSuccess{
                
            }else{
                
            }
        }
    }
    
    
    @IBAction func closeBtnACtion(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
