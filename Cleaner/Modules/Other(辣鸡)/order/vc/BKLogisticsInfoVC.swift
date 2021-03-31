//
//  BKLogisticsInfoVC.swift
//  BankeBus
//
//  Created by jemi on 2021/1/7.
//  Copyright © 2021 jemi. All rights reserved.
//

import UIKit

class BKLogisticsInfoVC: AppBaseVC {
    
    var orderNo = ""
    let nameBtn = QMUIButton()
    var model = BKOrderLogisticsModel()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = tableHeadView()
        tableView.tableFooterView = tableFootView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (m) in
            m.edges.equalTo(0)
        })
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleView?.title = "物流信息"
        tableView.backgroundColor = HEX("#F9F9F9")
        getData()
    }
    

}


extension BKLogisticsInfoVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.logisticsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = String(format: "cell%ld%ld", indexPath.section,indexPath.row)
        var cell:BKLogisticsInfoCell! = tableView.dequeueReusableCell(withIdentifier: cellID) as? BKLogisticsInfoCell
        if cell == nil {
            cell = BKLogisticsInfoCell(style: .default, reuseIdentifier: cellID)
        }
        cell.selectionStyle = .none
        cell.nameLabel.textColor = HEX("#999999")
        cell.tipsLabel.textColor = HEX("#999999")
        cell.topLine.isHidden = false
        cell.bottomLine.isHidden = false
        if indexPath.row == 0 {
            cell.topLine.isHidden = true
            cell.nameLabel.textColor = HEX("#333333")
            cell.tipsLabel.textColor = HEX("#333333")
        }
        
        if indexPath.row == model.logisticsList.count - 1 {
            cell.bottomLine.isHidden = true
        }
        
        cell.model = model.logisticsList[indexPath.row]
        return cell
    }
    
    
    func tableHeadView() -> UIView {
        let head = UIView(frame: CGRect(x: 0, y: 0, width: view.qmui_width, height: 42+16))
        
        let topHead = UIView()
//        topHead.size = CGSize(width: view.qmui_width-24, height: 42)
        topHead.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 8)
        topHead.backgroundColor = HEX("#F0F7FF")
        head.addSubview(topHead)
        topHead.snp.makeConstraints { (m) in
            m.leading.equalTo(12)
            m.top.equalTo(16)
            m.trailing.equalTo(-12)
            m.height.equalTo(42)
        }
        
        
        nameBtn.setTitle("暂无物流信息", for: .normal)
        nameBtn.setTitleColor(HEX("#333333"), for: .normal)
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        nameBtn.imagePosition = .right
        nameBtn.spacingBetweenImageAndTitle = 12
        nameBtn.contentHorizontalAlignment = .left
        topHead.addSubview(nameBtn)
        nameBtn.snp.makeConstraints { (m) in
            m.leading.equalTo(12)
            m.trailing.equalTo(-12)
            m.top.bottom.equalToSuperview()
        }
        nameBtn.rx.tap.subscribe(onNext: {[weak self] (tap) in
            let pboard : UIPasteboard = .general
            pboard.string = self!.model.logisticsNo
            if pboard.string!.isEmpty == false{
                QMUITips.show(withText: "复制成功")
            }
        }).disposed(by: rx.disposeBag)
        
        return head
    }
    
    func tableFootView() -> UIView {
        let foot = UIView(frame: CGRect(x: 0, y: 0, width: view.qmui_width, height: 25+16))
        
        
        let bottomFoot = UIView()
//        bottomFoot.size = CGSize(width: view.qmui_width-24, height: 25)
        bottomFoot.cornerWith(byRoundingCorners: [.bottomLeft,.bottomRight], radii: 8)
        bottomFoot.backgroundColor = HEX("#FFFFFF")
        foot.addSubview(bottomFoot)
        bottomFoot.snp.makeConstraints { (m) in
            m.leading.equalTo(12)
            m.top.equalToSuperview()
            m.trailing.equalTo(-12)
            m.height.equalTo(25)
        }
        
        return foot
    }
    
}


extension BKLogisticsInfoVC {
    
    func getData() {
        BKOrderLogisticsModel.getOrderLogisticsData(orderNo) {[weak self] (model) in
            var count = 0
            for item in model.logisticsList {
                if item.state == 0 && count == 0{
                    item.isFirst = true
                    count += 1
                }else {
                    item.isFirst = false
                }
                
            }
        
            self?.model = model
            self?.nameBtn.setTitle("\(model.logisticsBusiness)快递包裹：\(model.logisticsNo)", for: .normal)
            self?.nameBtn.setImage(UIImage(named: "物流复制"), for: .normal)
            if model.logisticsNo.isEmpty {
                self?.nameBtn.setTitle("暂无物流信息", for: .normal)
                self?.nameBtn.setImage(nil, for: .normal)
            }
            self?.tableView.reloadData()
        }
    }
    
}
