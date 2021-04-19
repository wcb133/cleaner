//
//  AddressBookManagerVC.swift
//  Cleaner
//
//  Created by fst on 2021/4/19.
//

import UIKit

class AddressBookManagerModel: NSObject {
    var imgName = ""
    var titleString = ""
}

class AddressBookManagerVC: AppBaseVC {
    
    var items:[AddressBookManagerModel] = []
    
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
        tableView.register(UINib(nibName: "\(AddressBookManagerCell.self)", bundle: nil), forCellReuseIdentifier: addressBookManagerCellID)
        tableView.separatorColor = HEX("#E8E9EA")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableContainerView.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.edges.equalTo(0)
        }
        return tableView
    }()
    
    var refreshUIBlock:()->Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView?.title = "通讯录优化"
        self.tableView.backgroundColor = .white
        
        let imgs = ["","",""]
        let titles = ["重复联系人","无号码","无姓名"]
        
        for (idx,title) in titles.enumerated() {
            let model = AddressBookManagerModel()
            model.imgName = imgs[idx]
            model.titleString = title
            self.items.append(model)
        }
        self.tableView.reloadData()
    }
    
}

extension AddressBookManagerVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addressBookManagerCellID, for: indexPath) as! AddressBookManagerCell
        cell.dataModel = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = AddressBookVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
//        let vc = DateOfOutCalendarVC()
//        vc.refreshUIBlock = self.refreshUIBlock
//        vc.isCalendar = indexPath.row == 0
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
