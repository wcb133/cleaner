//
//  BKInvoceInfoCell.swift
//  BankeBus
//
//  Created by jemi on 2021/1/22.
//  Copyright © 2021 jemi. All rights reserved.
//

import QMUIKit
import RxSwift

class BKInvoceInfoCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let textField = QMUITextField()
    
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
    }
    
    func loadUI() {
        
        
        nameLabel.textColor = HEX("#333333")
        nameLabel.font = MediumFont(size: 14)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(22)
            m.centerY.equalToSuperview()
            m.height.equalTo(20)
            m.width.equalTo(80)
        }
        
        textField.textColor = HEX("#333333")
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.placeholderColor = HEX("#999999")
        textField.textAlignment = .right
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (m) in
            m.trailing.equalTo(-22)
            m.centerY.equalToSuperview()
            m.height.equalTo(30)
            m.leading.equalTo(nameLabel.snp_trailing).offset(10)
        }
        
        let line = UIView()
        line.backgroundColor = HEX("#F1F1F1")
        contentView.addSubview(line)
        line.snp.makeConstraints { (m) in
            m.leading.top.trailing.equalToSuperview()
            m.height.equalTo(1)
        }
    }
    
    //单元格重用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
