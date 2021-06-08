//
//  AboutVC.swift
//  Cleaner
//
//  Created by wcb on 2021/3/28.
//

import UIKit


let cellID = "cellID"
class AboutUsInfoVC: AppBaseVC {
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorColor = HEX("#E8E9EA")
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
    
    let items = [localizedString("Privacy Policy"),localizedString("User Agreement"),localizedString("Questions and Answers")]
    var paths:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView?.title = localizedString("About")
        self.tableView.backgroundColor = .white
        
        let pathOne = Bundle.main.path(forResource: "隐私政策", ofType: "html") ?? ""
        let pathTwo =  pathOne
        let pathThree = Bundle.main.path(forResource: "常见问题", ofType: "html") ?? ""
        paths.append(pathOne)
        paths.append(pathTwo)
        paths.append(pathThree)
        
        
        
    }
    
}

extension AboutUsInfoVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.textLabel?.textColor = HEX("333333")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AppWebVC()
        vc.titleStr = items[indexPath.row]
        vc.path = paths[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
