//
//  DateOfOutCalendarVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit
import QMUIKit


class CalendarAndReminderVC: AppBaseVC {
    
    var isCalendar = true
    
    @IBOutlet weak var deleteBtn: QMUIButton!
    
    @IBOutlet weak var bottomInsetCons: NSLayoutConstraint!
    
    var itemDatas:[CalendarEventModel] = []
    
    var refreshUIBlock:()->Void = {}
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = 65
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor =  .white
        tableView.register(UINib(nibName: "\(CalendarAndReminderCell.self)", bundle: nil), forCellReuseIdentifier: dateOfOutCalendarCellID)
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
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.left.top.right.equalTo(0)
            m.bottom.equalTo(self.deleteBtn.snp.top).offset(-15)
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView?.title = isCalendar ? "过期日历":"过期提醒事项"
        deleteBtn.layer.cornerRadius = 24
        deleteBtn.layer.masksToBounds = true
        setupEmptyView()
        self.bottomInsetCons.constant = 20 + cIndicatorHeight
        DispatchQueue.main.async {
            if self.isCalendar {
                CalendarAnalyseTool.shared.getOutOfDateCalendarEvent { calendarEventModels in
                    QMUITips.hideAllTips()
                    self.itemDatas = calendarEventModels
                    if calendarEventModels.isEmpty {
                        self.showEmptyView()
                        self.deleteBtn.isHidden = true
                    }
                    self.tableView.reloadData()
                }
            }else{
                CalendarAnalyseTool.shared.getOutOfDateReminder { calendarEventModels in
                    QMUITips.hideAllTips()
                    self.itemDatas = calendarEventModels
                    if calendarEventModels.isEmpty {
                        self.showEmptyView()
                        self.deleteBtn.isHidden = true
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func deleteBtnAction(_ sender: QMUIButton) {
        
        if DateTool.shared.isExpired() {
            let vc = PurchaseServiceVC()
            let nav = BaseNav(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
            return
        }
        
        
        let message = self.isCalendar ?"确定删除所选过期节日?":"确定删除所选过期事项?"
        ImageAndVideoAnalyseTool.shared.tipWith(message: message) {
            self.deleteData()
        }
    }
    
    func deleteData() {
        var deleteEvents:[CalendarEventModel] = []
        for itemData in itemDatas {
            if itemData.isSelected {
                deleteEvents.append(itemData)
            }
        }
        if deleteEvents.isEmpty {
            QMUITips.show(withText: isCalendar ? "请勾选要删除的节日":"请勾选要删除的事项")
            return
        }
        
        QMUITips.showLoading(in: self.navigationController!.view)
        
        if isCalendar {
            CalendarAnalyseTool.shared.deleteEvents(eventMoels: deleteEvents) { isSuccess in
                QMUITips.hideAllTips()
                if isSuccess {
                    
                    self.itemDatas.removeAll { eventModel -> Bool in
                        return eventModel.isSelected
                    }
                    
                    self.refreshUIBlock()
                    QMUITips.show(withText: "已删除")
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }else{
            CalendarAnalyseTool.shared.deleteReminders(reminderModels: deleteEvents) {isSuccess  in
                QMUITips.hideAllTips()
                if isSuccess {
                    self.itemDatas.removeAll { eventModel -> Bool in
                        return eventModel.isSelected
                    }
                    QMUITips.show(withText: "已删除")
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func setupEmptyView() {
        showEmptyView(with: UIImage(named: "无内容"), text: "未发现可优化项目", detailText: nil, buttonTitle: "", buttonAction: nil)
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
    
    override func navigationBarBackgroundImage() -> UIImage? {
        return UIImage.qmui_image(with: HEX("28B3FF"))
    }
    
    override func navigationBarTintColor() -> UIColor? {
        return .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

extension CalendarAndReminderVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dateOfOutCalendarCellID, for: indexPath) as! CalendarAndReminderCell
        cell.dataModel = self.itemDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.itemDatas[indexPath.row]
        model.isSelected = !model.isSelected
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
