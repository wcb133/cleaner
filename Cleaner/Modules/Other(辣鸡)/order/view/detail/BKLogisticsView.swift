//
//  BKLogisticsView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKLogisticsView: UIView,LoadNibable {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var model = BKOrderLogisticsModel() {
        didSet {
            nameLabel.text = model.logisticsList.first?.context
            timeLabel.text = model.logisticsList.first?.timeLine
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
}
