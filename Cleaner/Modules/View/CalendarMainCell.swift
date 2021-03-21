//
//  CalendarMainCell.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let calendarMainCellID = "calendarMainCellID"

class CalendarMainCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLab: UILabel!
    
    var isCalendar:Bool = false{
        didSet{
            if self.isCalendar {
                self.imgView.image = UIImage(named: "日历")
                self.titleLab.text = "过期日历"
                
            }else{
                self.imgView.image = UIImage(named: "提醒")
                self.titleLab.text = "过期提醒事项"
            }
            
        }
    }
}
