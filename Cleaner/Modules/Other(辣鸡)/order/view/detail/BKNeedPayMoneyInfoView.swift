//
//  BKNeedPayMoneyInfoView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKNeedPayMoneyInfoView: UIView,LoadNibable {

    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!
    
    @IBOutlet weak var payName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        cornerWith(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 8)
    }
}
