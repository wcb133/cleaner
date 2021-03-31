//
//  BKBillInfoView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKBillInfoView: UIView,LoadNibable {

    
    @IBOutlet weak var billNameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var model = BKInvoiceModel() {
        didSet {
            billNameLabel.text = model.invPayee
            nameLabel.text = model.invConsignee
            emailLabel.text = model.invEmail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
