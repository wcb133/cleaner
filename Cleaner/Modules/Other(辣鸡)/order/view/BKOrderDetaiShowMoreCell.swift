//
//  BKOrderDetaiShowMoreCell.swift
//  BankeBus
//
//  Created by jemi on 2021/3/22.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

let OrderDetaiShowMoreCellID = "OrderDetaiShowMoreCell"
class BKOrderDetaiShowMoreCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var accetMoneyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        monthLabel.textAlignment = .center
        pointLabel.textAlignment = .center
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
