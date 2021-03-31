//
//  DateOfOutCalendarCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let dateOfOutCalendarCellID = "dateOfOutCalendarCellID"
class CalendarAndReminderCell: UITableViewCell {
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var subTitleLab: UILabel!
    
    
    @IBOutlet weak var statusBtn: UIButton!
    
    var dataModel = CalendarEventModel(){
        didSet{
            self.titleLab.text = dataModel.title
            self.subTitleLab.text = dataModel.timeString
            self.statusBtn.isSelected = dataModel.isSelected
        }
    }
    
}
