//
//  BKOrderDetailBottomCell.swift
//  BankeBus
//
//  Created by fst on 2021/3/30.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

let orderDetailBottomCellID = "orderDetailBottomCellID"
class BKOrderDetailBottomCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
