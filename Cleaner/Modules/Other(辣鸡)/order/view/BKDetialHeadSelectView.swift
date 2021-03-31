//
//  BKDetialHeadSelectView.swift
//  BankeBus
//
//  Created by jemi on 2021/3/23.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKDetialHeadSelectView: UIView,LoadNibable {
    
    
    @IBOutlet weak var persionBtn: UIButton!
    
    @IBOutlet weak var comBtn: UIButton!
    
    @IBOutlet weak var readmeBtn: UIButton!
    
    var showRedmeBlock:(()->Void) = {}
    
    var clickPersoBlock:((Int)->Void) = {_ in}
    
    var isSelectPersion = true {
        didSet {
            if isSelectPersion {
                persionBtn.layer.borderColor = UIColor.clear.cgColor
                persionBtn.backgroundColor = HEX("#3890F9")
                persionBtn.setTitleColor(.white, for: .normal)
                comBtn.layer.borderColor = HEX("#999999").cgColor
                comBtn.backgroundColor = .white
                comBtn.setTitleColor(HEX("#333333"), for: .normal)
            }else {
                comBtn.layer.borderColor = UIColor.clear.cgColor
                comBtn.backgroundColor = HEX("#3890F9")
                comBtn.setTitleColor(.white, for: .normal)
                persionBtn.layer.borderColor = HEX("#999999").cgColor
                persionBtn.backgroundColor = .white
                persionBtn.setTitleColor(HEX("#333333"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        persionBtn.layer.cornerRadius = 15
        persionBtn.layer.masksToBounds = true
        persionBtn.layer.borderWidth = 1
        persionBtn.layer.borderColor = HEX("#999999").cgColor
        comBtn.layer.cornerRadius = 15
        comBtn.layer.masksToBounds = true
        comBtn.layer.borderWidth = 1
        comBtn.layer.borderColor = HEX("#999999").cgColor
    }
    
    @IBAction func showRemeAction(_ sender: Any) {
        showRedmeBlock()
    }
    
    @IBAction func persionAction(_ sender: Any) {
        clickPersoBlock(1)
    }
    @IBAction func compoAction(_ sender: Any) {
        clickPersoBlock(2)
    }
}
