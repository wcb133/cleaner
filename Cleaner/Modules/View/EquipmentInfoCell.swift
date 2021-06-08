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
        selectionStyle = .none
    }
    
    var dataModel:EquipmentInfoModel = EquipmentInfoModel(){
        didSet{
            self.titleLab.text = localizedString(dataModel.title)
            self.contentLab.text = localizedString(dataModel.content)
        }
    }
    
}
