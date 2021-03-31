//
//  BKInvoceView.swift
//  BankeBus
//
//  Created by jemi on 2021/1/22.
//  Copyright © 2021 jemi. All rights reserved.
//

import QMUIKit

class BKInvoceView: UIView,LoadNibable {

    
    @IBOutlet weak var noneedInvoceBtn: QMUIButton!
    
    @IBOutlet weak var needIncoveBtn: QMUIButton!
    
    @IBOutlet weak var composeBtn: QMUIButton!
    
    @IBOutlet weak var personBtn: QMUIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noneedInvoceBtn.isSelected = true
        personBtn.isSelected = true
        noneedInvoceBtn.spacingBetweenImageAndTitle = 8
        needIncoveBtn.spacingBetweenImageAndTitle = 8
        composeBtn.spacingBetweenImageAndTitle = 8
        personBtn.spacingBetweenImageAndTitle = 8
        
    }

}
