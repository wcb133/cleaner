//
//  ContactHeaderView.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit

let contactHeaderViewID = "contactHeaderViewID"
class AddressBookHeaderView: UITableViewHeaderFooterView {

    let lab = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = HEX("ECECEC")
        lab.font = MediumFont(size: 17)
        lab.textColor = HEX("333333")
        self.contentView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.left.equalTo(15)
            m.top.bottom.equalTo(0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
