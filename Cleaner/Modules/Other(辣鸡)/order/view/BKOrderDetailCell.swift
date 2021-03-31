//
//  BKOrderDetailCell.swift
//  BankeBus
//
//  Created by jemi on 2020/12/2.
//  Copyright © 2020 jemi. All rights reserved.
//

import UIKit

class BKOrderDetailCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    let line = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
    }
    
    func loadUI() {
        nameLabel.text = "订单编号"
        nameLabel.textColor = HEX("#333333")
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(24)
            m.top.equalTo(12)
            m.height.equalTo(22)
        }
        
        valueLabel.text = "o202011301420492964052"
        valueLabel.textColor = HEX("#333333")
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (m) in
            m.trailing.equalTo(-24)
            m.top.equalTo(12)
            m.height.equalTo(22)
        }
        
        
        line.backgroundColor = HEX("#F1F1F1")
        contentView.addSubview(line)
        line.snp.makeConstraints { (m) in
            m.leading.equalTo(18)
            m.trailing.equalTo(-18)
            m.bottom.equalToSuperview()
            m.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
