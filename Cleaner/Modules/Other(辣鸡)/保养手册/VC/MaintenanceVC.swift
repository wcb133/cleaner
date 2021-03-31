//
//  MaintenanceVC.swift
//  BankeBus
//
//  Created by fst on 2021/3/30.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class MaintenanceVC: AppBaseVC {

    
    @IBOutlet weak var selectCarBtn: UIButton!
    
    @IBOutlet weak var selectCarContainerView: UIView!
    
    @IBOutlet weak var carLogo: UIImageView!
    
    @IBOutlet weak var carBranchLab: UILabel!
    
    @IBOutlet weak var carStyleLab: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView?.title = "保养手册"
        self.view.backgroundColor = HEX("#F5F5F5")
    }
    

}
