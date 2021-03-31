//
//  ContactCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let contactCellID = "contactCellID"
class AddressBookCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    
    @IBOutlet weak var telLab: UILabel!
    
    
    @IBOutlet weak var selectStatuBtn: UIButton!
    
    
    var dataModel = ContactModel(){
        didSet{
            self.nameLab.text = dataModel.name
            self.telLab.text = dataModel.tel
            self.selectStatuBtn.isSelected = dataModel.isSelected
        }
    }
    
}
