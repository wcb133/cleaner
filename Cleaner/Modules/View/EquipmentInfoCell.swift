//
//  EquipmentInfoCell.swift
//  Cleaner
//
//  Created by fst on 2021/4/2.
//

import UIKit

let equipmentInfoCellID = "equipmentInfoCellID"
class EquipmentInfoCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var contentLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var dataModel:EquipmentInfoModel = EquipmentInfoModel(){
        didSet{
            self.titleLab.text = dataModel.title
            self.contentLab.text = dataModel.content
        }
    }
    
}
