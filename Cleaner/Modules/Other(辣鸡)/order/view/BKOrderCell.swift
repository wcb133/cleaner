//
//  BKOrderCell.swift
//  BankeBus
//
//  Created by jemi on 2020/12/2.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

let OrderCellID = "OrderCellID"
class BKOrderCell: UITableViewCell {
    
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var carNoLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var giveMoneyDateLabel: UILabel!
    
    @IBOutlet weak var timesLabel: UILabel!
    
    @IBOutlet weak var carTimeLabel: UILabel!
    
    @IBOutlet weak var orderTimeLabel: UILabel!
    
    @IBOutlet weak var statusNameLabel: UILabel!
    
    
    var status:BKOrderStatus = .all {
        didSet {
            if status == .dispose {
                statusNameLabel.textColor = HEX("#C8B92A")
            }else if status == .accept {
                statusNameLabel.textColor = HEX("#507FED")
            }else if status == .refuse {
                statusNameLabel.textColor = HEX("#DB3E8C")
            }else if status == .complete {
                statusNameLabel.textColor = HEX("#50C46E")
            }else {
                
            }
        }
    }
    
    var model = BKOrderModel() {
        didSet {
            carNoLabel.text = model.car.carValue.carNo
            typeLabel.text = model.payTypeName
            moneyLabel.text = String(format: "%.2f元", model.rentAmount)
            
            if model.status == 0 {
                giveMoneyDateLabel.text = model.canBillingAgent ? "自主选择" : "本人开票"
            }else {
                giveMoneyDateLabel.text = model.canBillingAgent ? "企业代开" : "本人开票"
            }
            timesLabel.text = "\(model.period)"
//            carTimeLabel.text = model.rent.startTime.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY-MM-dd") + " 至 " + model.rent.endTime.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "YYYY-MM-dd")
            orderTimeLabel.text = model.auditValue.creationTime
            statusNameLabel.text = model.statusName
            if model.status == 0 {
                status = .dispose
            }else if model.status == 1 {
                status = .refuse
            }else if model.status == 2 {
                status = .accept
            }else {
                status = .complete
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = HEX("#F9F9F9")
        contentView.backgroundColor = HEX("#F9F9F9")
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
    }
    
    
}
