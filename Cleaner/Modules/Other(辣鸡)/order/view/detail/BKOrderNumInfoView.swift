//
//  BKOrderNumInfoView.swift
//  BankeBus
//
//  Created by jemi on 2020/12/30.
//  Copyright © 2020 jemi. All rights reserved.
//

import QMUIKit

class BKOrderNumInfoView: UIView,LoadNibable {

    
    @IBOutlet weak var paynameLabel: UILabel!
    
    @IBOutlet weak var orderNoLabel: UILabel!
    
    @IBOutlet weak var payTypeNumLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    
    @IBAction func copyOrderN0Action(_ sender: Any) {
        let pboard : UIPasteboard = .general
        pboard.string = orderNoLabel.text
        if pboard.string!.isEmpty == false{
            QMUITips.show(withText: "复制成功")
        }
    }
    
    
    @IBAction func copyPayTypeNumAction(_ sender: Any) {
        let pboard : UIPasteboard = .general
        pboard.string = payTypeNumLabel.text
        if pboard.string!.isEmpty == false{
            QMUITips.show(withText: "复制成功")
        }
    }
    
}
