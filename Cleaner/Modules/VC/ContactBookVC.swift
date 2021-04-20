//
//  ContactBookVC.swift
//  Cleaner
//
//  Created by fst on 2021/4/20.
//

import QMUIKit

class ContactBookVC: AppBaseVC {
    
    var isNoNameData = true
    
    var itemDatas:[ContactModel] = []
    
    @IBOutlet weak var deleteBtn: QMUIButton!
    
    var refreshUIBlock:()->Void = {}
    
    @IBOutlet weak var bottomInsetCons: NSLayoutConstraint!
    
    lazy var tableContainerView:UIView = {
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = .white
        self.view.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.top.equalTo(0)
            m.bottom.equalTo(self.deleteBtn.snp.top).offset(-15)
        }
        return tableContainerView
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = 58
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor =  .white
        tableView.register(UINib(nibName: "\(AddressBookCell.self)", bundle: nil), forCellReuseIdentifier: contactCellID)
//        tableView.register(AddressBookHeaderView.self, forHeaderFooterViewReuseIdentifier: contactHeaderViewID)
        tableView.separatorColor = HEX("#E8E9EA")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = false
        self.bottomInsetCons.constant = 20 + cIndicatorHeight
        setupEmptyView()
        titleView?.title = self.isNoNameData ? "无姓名":"空号码"
        titleView?.titleLabel.textColor = .white
        deleteBtn.layer.cornerRadius = 24
        deleteBtn.layer.masksToBounds = true
        DispatchQueue.main.async {
            let analyseTool = ContactAnalyseTool.shared
            self.itemDatas = self.isNoNameData ? analyseTool.noNameContactModels:analyseTool.noTelContactModels
            self.tableView.reloadData()
            if self.itemDatas.isEmpty {
                self.showEmptyView()
                self.deleteBtn.isHidden = true
            }
        }
    }
    func setupEmptyView() {
        showEmptyView(with: UIImage(named: "无内容"), text: "未发现相应联系人", detailText: nil, buttonTitle: "", buttonAction: nil)
        emptyView?.imageViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        emptyView?.textLabelFont = .systemFont(ofSize: 14)
        emptyView?.textLabelTextColor = HEX("#7C8A9C")
        emptyView?.verticalOffset = 0
        hideEmptyView()
    }
    
    override func showEmptyView() {
        if emptyView == nil {
            emptyView = QMUIEmptyView(frame: tableView.bounds)
        }
        tableView.addSubview(emptyView!)
        emptyView?.frame = CGRect(x: 0, y: 0, width: cScreenWidth, height: tableView.qmui_height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyView?.frame = CGRect(x: 0, y: 0, width: cScreenWidth, height: tableView.qmui_height)
    }
    

    @IBAction func deleteBtnAction(_ sender: QMUIButton) {
        
        if DateTool.shared.isExpired() {
            let vc = PurchaseServiceVC()
            let nav = AppBaseNav(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
            return
        }
        
        
        ImageAndVideoAnalyseTool.shared.tipWith(message: "删除后将无法恢复，确定删除所选联系人?") {
            var selectContactModels:[ContactModel] = []
            for itemData in self.itemDatas {
                    if itemData.isSelected {
                        selectContactModels.append(itemData)
                    }
            }
            
            if selectContactModels.isEmpty {
                QMUITips.show(withText: "请勾选要删除的联系人")
                return
            }
            
            QMUITips.showLoading(in: self.navigationController!.view)
            //移除数据源
            self.itemDatas.removeAll { contactModel -> Bool in
              return  contactModel.isSelected
            }
            
            ContactAnalyseTool.shared.deleteSelectContacts(contacts: selectContactModels)

            self.tableView.reloadData()
            QMUITips.hideAllTips()
            self.refreshUIBlock()
            QMUITips.show(withText: "已删除")
            if self.itemDatas.isEmpty {
                self.showEmptyView()
                self.deleteBtn.isHidden = true
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension ContactBookVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  itemDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCellID, for: indexPath) as! AddressBookCell
        cell.isOnlyShowMainLab = true
        cell.dataModel = itemDatas[indexPath.row]
        return cell
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: contactHeaderViewID) as! AddressBookHeaderView
        let itemData = itemDatas[section]
        sectionHeaderView.lab.text = itemData.name
        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataModel = self.itemDatas[indexPath.row]
        dataModel.isSelected = !dataModel.isSelected
        tableView.reloadRows(at: [indexPath], with: .none)
        
    }
}

