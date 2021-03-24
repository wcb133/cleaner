//
//  ContactVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit
import QMUIKit

class ContactVC: BaseVC {
    
    var itemDatas:[ContactSectonModel] = []
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var topViewH: NSLayoutConstraint!
    @IBOutlet weak var contactNumLab: UILabel!
    
    @IBOutlet weak var groupNumLab: UILabel!
    
    
    @IBOutlet weak var bottomLab: UILabel!
    @IBOutlet weak var deleteBtn: QMUIButton!
    
    @IBOutlet weak var bottomInsetCons: NSLayoutConstraint!
    lazy var tableContainerView:UIView = {
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = .white
        self.view.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.top.equalTo(self.topView.snp.bottom).offset(-8)
            m.bottom.equalTo(self.bottomLab.snp.top).offset(-15)
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
        tableView.register(UINib(nibName: "\(ContactCell.self)", bundle: nil), forCellReuseIdentifier: contactCellID)
        tableView.register(ContactHeaderView.self, forHeaderFooterViewReuseIdentifier: contactHeaderViewID)
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
        titleView?.title = "通讯录优化"
        titleView?.titleLabel.textColor = .white
//        self.topViewH.constant = iPhoneX ? 220: 200
        deleteBtn.layer.cornerRadius = 24
        deleteBtn.layer.masksToBounds = true
        DispatchQueue.main.async {
            ContactManager.shared.getRepeatContact { (contactSectonModels, total) in
                self.itemDatas = contactSectonModels
                self.contactNumLab.text = "\(total)"
                self.bottomLab.text = "发现\(contactSectonModels.count)个重复联系人"
                self.tableView.reloadData()
                if contactSectonModels.isEmpty {
                    self.showEmptyView()
                    self.bottomLab.text = nil
                    self.deleteBtn.isHidden = true
                }
            }
        }
    }
    func setupEmptyView() {
        showEmptyView(with: UIImage(named: "无内容"), text: "未发现重复联系人", detailText: nil, buttonTitle: "", buttonAction: nil)
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
        self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 8)
    }
    
    
    @IBAction func deleteBtnAction(_ sender: QMUIButton) {
        
        PhotoAndVideoManager.shared.tipWith(message: "删除后将无法恢复，确定删除所选联系人?") {
            var selectContactModels:[ContactModel] = []
            for itemData in self.itemDatas {
                for model in itemData.contactModels {
                    if model.isSelected {
                        selectContactModels.append(model)
                    }
                }
            }
            
            if selectContactModels.isEmpty {
                QMUITips.show(withText: "请勾选要删除的联系人")
                return
            }
            
            QMUITips.showLoading(in: self.navigationController!.view)
            ContactManager.shared.deleteContacts(contacts: selectContactModels)
            //移除数据源
            for itemData in self.itemDatas {
                var sourceContactModels = itemData.contactModels
                for (idx,model) in itemData.contactModels.enumerated() {
                    if model.isSelected {
                        sourceContactModels.remove(at: idx)
                    }
                }
                itemData.contactModels = sourceContactModels
                
            }
            self.tableView.reloadData()
            QMUITips.hideAllTips()
            QMUITips.show(withText: "已删除")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension ContactVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemDatas.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemData = itemDatas[section]
        return  itemData.contactModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCellID, for: indexPath) as! ContactCell
        let itemData = itemDatas[indexPath.section]
        cell.dataModel = itemData.contactModels[indexPath.row]
        return cell
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: contactHeaderViewID) as! ContactHeaderView
        let itemData = itemDatas[section]
        sectionHeaderView.lab.text = itemData.name
        return sectionHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let itemData = itemDatas[indexPath.section]
        let dataModel = itemData.contactModels[indexPath.row]
        dataModel.isSelected = !dataModel.isSelected
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

