//
//  BKShowReadMeInfoView.swift
//  BankeBus
//
//  Created by jemi on 2021/3/22.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKShowReadMeInfoView: UIView,LoadNibable {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var contentLabel: QMUILabel!
    

    var closeBlock:()->Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 6
        bgView.layer.masksToBounds = true
        contentLabel.qmui_lineHeight = 22.5
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        closeBlock()
    }
    
}
