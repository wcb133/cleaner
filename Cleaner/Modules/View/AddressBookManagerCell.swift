//
//  CalendarMainCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let addressBookManagerCellID = "addressBookManagerCellID"

class AddressBookManagerCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var numLab: UILabel!
    
    
    
    var dataModel:AddressBookManagerModel = AddressBookManagerModel(){
        didSet{
            self.imgView.image = UIImage(named: self.dataModel.imgName)
            self.titleLab.text = localizedString(self.dataModel.titleString)
            self.numLab.text = "\(self.dataModel.num)"
        }
    }
}
