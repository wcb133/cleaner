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
    
    @IBOutlet weak var mainLab: UILabel!
    
    @IBOutlet weak var selectStatuBtn: UIButton!
    
    var isOnlyShowMainLab = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var dataModel = ContactModel(){
        didSet{
            self.selectStatuBtn.isSelected = dataModel.isSelected
            if self.isOnlyShowMainLab {
                self.nameLab.isHidden = true
                self.telLab.isHidden = true
                self.mainLab.isHidden = false
                self.mainLab.text = self.dataModel.name.isEmpty ? dataModel.tel:dataModel.name
            }else{
                self.nameLab.isHidden = false
                self.telLab.isHidden = false
                self.mainLab.isHidden = true
                self.nameLab.text = dataModel.name
                self.telLab.text = dataModel.tel
            }
        }
    }
    
}
