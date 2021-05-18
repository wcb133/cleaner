//
//  EquipmentInfoVC.swift
//  Cleaner
//
//  Created by fst on 2021/4/2.
//

import UIKit

class EquipmentInfoVC: AppBaseVC {
    
    lazy var tableContainerView:UIView = {
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = .white
        self.view.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { (m) in
            m.edges.equalTo(0)
        }
        return tableContainerView
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = 54
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor =  .white
        tableView.register(UINib(nibName: "\(EquipmentInfoCell.self)", bundle: nil), forCellReuseIdentifier: equipmentInfoCellID)
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableContainerView.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.edges.equalTo(0)
        }
        return tableView
    }()
    
    
    
    var items:[EquipmentInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView?.title = "设备信息"
        self.tableView.backgroundColor = .white
        let titles:[String] = ["手机名称","手机型号","系统版本","屏幕分辨率","Retina屏幕","电池电量","启动时间"]
        
        let imageCompare = ImageCompareTool()
        let scale = UIScreen.main.scale
        let currentDevice = UIDevice.current
        let name = currentDevice.name
        let type = imageCompare.getDeviceName() ?? ""
        let version = currentDevice.systemName + currentDevice.systemVersion
        let phoneSize = String(format: "%.0fx%.0f", cScreenWidth * scale,cScreenHeight * scale)
        let isRetina = "是"
        let startTime = imageCompare.bootTime()
        currentDevice.isBatteryMonitoringEnabled = true
        let batteryLevelNum = currentDevice.batteryLevel < 0 ? currentDevice.batteryLevel * -1.0 :currentDevice.batteryLevel
        let batteryLevel = String(format: "%.0f%%", batteryLevelNum * 100)
        
        let contents:[String] = [name,type,version,phoneSize,isRetina,batteryLevel,startTime!]
        
        for (idx,title) in titles.enumerated() {
            let model = EquipmentInfoModel()
            model.title = title
            model.content = contents[idx]
            items.append(model)
        }
        self.tableView.reloadData()
    }
    
}

extension EquipmentInfoVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: equipmentInfoCellID, for: indexPath) as! EquipmentInfoCell
        cell.dataModel = items[indexPath.row]
        return cell
    }
    
}
