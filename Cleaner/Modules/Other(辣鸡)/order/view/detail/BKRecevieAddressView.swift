//
//  BKRecevieAddressView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKRecevieAddressView: UIView,LoadNibable {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    var model = BKReceAddressModel() {
        didSet {
            nameLabel.text = model.consignee
            phoneLabel.text = model.mobile
            addressLabel.text = model.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
