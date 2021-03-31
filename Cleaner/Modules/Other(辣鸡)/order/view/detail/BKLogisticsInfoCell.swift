//
//  BKLogisticsInfoCell.swift
//  BankeBus
//
//  Created by jemi on 2021/1/7.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKLogisticsInfoCell: UITableViewCell {
    
    let bgView = UIView()
    let timeLabel = UILabel()
    let htimeLabel = UILabel()
    let img = UIImageView()
    let topLine = UIView()
    let bottomLine = UIView()
    let nameLabel = UILabel()
    let tipsLabel = UILabel()
    
    var model = BKLogisticsModel() {
        didSet {
//
//            timeLabel.text = model.timeLine.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "MM-dd")
//            htimeLabel.text = model.timeLine.hc_dateFormater(fromDateFormat: "yyyy-MM-dd HH:mm:ss", toDateFormat: "HH:mm")
            
            //状态: 0=在途，1=揽收，2=疑难，3=签收，4=退签，5=派件，6=退回
            if model.state == 0 {
                
                if model.isFirst {
                    img.image = UIImage(named: "物流运输中编组 4")
                    timeLabel.snp.updateConstraints { (m) in
                        m.top.equalTo(15)
                    }
                    img.snp.updateConstraints { (m) in
                        m.size.equalTo(CGSize(width: 31, height: 31))
                    }
                    nameLabel.font = UIFont.systemFont(ofSize: 15)
                    tipsLabel.text = model.context
                    nameLabel.text = "运输中"
                }else {
                    img.image = UIImage(named: "物流椭圆形")
                    nameLabel.font = UIFont.systemFont(ofSize: 13)
                    nameLabel.text = model.context
                    tipsLabel.text = ""
                    img.snp.updateConstraints { (m) in
                        m.size.equalTo(CGSize(width: 7, height: 7))
                    }
                    timeLabel.snp.updateConstraints { (m) in
                        m.top.equalTo(3)
                    }
                }
                
                
                
                
            }else {
                timeLabel.snp.updateConstraints { (m) in
                    m.top.equalTo(15)
                }
                img.snp.updateConstraints { (m) in
                    m.size.equalTo(CGSize(width: 31, height: 31))
                }
                nameLabel.font = UIFont.systemFont(ofSize: 15)
                tipsLabel.text = model.context
                nameLabel.text = model.statusDesc
                
                switch model.state {
                case -1:
                    img.image = UIImage(named: "物流已发货编组 6")
                case -2:
                    img.image = UIImage(named: "物流已下单编组 7")
                case 1:
                    img.image = UIImage(named: "物流已揽件编组 5")
                case 2:
                    img.image = UIImage(named: "物流异常")
                case 5:
                    img.image = UIImage(named: "物流派件中编组 2")
                default:
                    img.image = UIImage(named: "物流已签收编组 3")
                }
                
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        bgView.cornerWith(byRoundingCorners: [.bottomLeft,.bottomLeft], radii: 8)
    }
    
    func loadUI() {
        contentView.backgroundColor = HEX("#F9F9F9")
        bgView.backgroundColor = HEX("#FFFFFF")
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (m) in
            m.leading.equalTo(12)
            m.width.equalTo(cScreenWidth-24)
            m.top.bottom.equalToSuperview()
        }
        
        timeLabel.text = "12-15"
        timeLabel.textColor = HEX("#999999")
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        bgView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(11)
            m.top.equalTo(15)
            m.width.equalTo(35)
            m.height.equalTo(17)
        }
        htimeLabel.text = "07:46"
        htimeLabel.textColor = HEX("#999999")
        htimeLabel.font = UIFont.systemFont(ofSize: 11)
        bgView.addSubview(htimeLabel)
        htimeLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(11)
            m.top.equalTo(timeLabel.snp_bottom).offset(1)
            m.height.equalTo(16)
        }
        
        topLine.backgroundColor = HEX("#F1F1F1")
        bgView.addSubview(topLine)
        topLine.snp.makeConstraints { (m) in
            m.leading.equalTo(timeLabel.snp_trailing).offset(19)
            m.top.equalToSuperview()
            m.size.equalTo(CGSize(width: 1, height: 19))
        }
        
        img.image = UIImage(named: "物流已下单编组 7")
        bgView.addSubview(img)
        img.snp.makeConstraints { (m) in
            m.centerX.equalTo(topLine)
            m.top.equalTo(topLine.snp_bottom)
            m.size.equalTo(CGSize(width: 31, height: 31))
        }
        
        bottomLine.backgroundColor = HEX("#F1F1F1")
        bgView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (m) in
            m.centerX.width.equalTo(topLine)
            m.top.equalTo(img.snp_bottom)
            m.bottom.equalToSuperview()
        }
        
        nameLabel.text = "已下单"
        nameLabel.numberOfLines = 0
        nameLabel.textColor = HEX("#999999")
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(img.snp_trailing).offset(8)
            m.centerY.equalTo(img)
            m.trailing.equalTo(-16)
        }
        
        tipsLabel.text = "已下单，等待打包发货"
        tipsLabel.numberOfLines = 0
        tipsLabel.textColor = HEX("#999999")
        tipsLabel.font = UIFont.systemFont(ofSize: 13)
        bgView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (m) in
            m.leading.equalTo(nameLabel)
            m.top.equalTo(nameLabel.snp_bottom).offset(4)
            m.trailing.equalTo(-16)
            m.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
