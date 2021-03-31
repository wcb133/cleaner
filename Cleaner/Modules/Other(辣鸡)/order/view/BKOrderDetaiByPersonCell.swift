//
//  BKOrderDetaiByPersonCell.swift
//  BankeBus
//
//  Created by jemi on 2021/3/22.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

let OrderDetaiByPersonCellID = "OrderDetaiByPersonCellID"
class BKOrderDetaiByPersonCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
