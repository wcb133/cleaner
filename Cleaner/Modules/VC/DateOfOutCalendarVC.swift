//
//  DateOfOutCalendarVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit
import QMUIKit


class DateOfOutCalendarVC: BaseVC {
    
    var isCalendar = true
    
    @IBOutlet weak var deleteBtn: QMUIButton!
    
    @IBOutlet weak var bottomInsetCons: NSLayoutConstraint!
    
    var itemDatas:[CalendarEventModel] = []
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = 65
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor =  .white
        tableView.register(UINib(nibName: "\(DateOfOutCalendarCell.self)", bundle: nil), forCellReuseIdentifier: dateOfOutCalendarCellID)
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
                CalendarManager.shared.getOutOfDateCalendarEvent { calendarEventModels in
                    QMUITips.hideAllTips()
                    self.itemDatas = calendarEventModels
                    if calendarEventModels.isEmpty {
                        self.showEmptyView()
                        self.deleteBtn.isHidden = true
                    }
                    self.tableView.reloadData()
                }
            }else{
                CalendarManager.shared.getOutOfDateReminder { calendarEventModels in
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
        
        var deleteEvents:[CalendarEventModel] = []
        for itemData in itemDatas {
            if itemData.isSelected {
                deleteEvents.append(itemData)
            }
        }
        if deleteEvents.isEmpty {
            QMUITips.show(withText: isCalendar ? "请勾选要删除的日期":"请勾选要删除的事项")
            return
        }
        
        QMUITips.showLoading(in: self.navigationController!.view)
        
        if isCalendar {
            CalendarManager.shared.deleteEvents(eventMoels: deleteEvents) { isSuccess in
                QMUITips.hideAllTips()
                if isSuccess {
                    var tmpItemDatas = self.itemDatas
                    for (idx,itemData) in itemDatas.enumerated() {
                        if itemData.isSelected {
                            tmpItemDatas.remove(at: idx)
                        }
                    }
                    self.itemDatas = tmpItemDatas
                    QMUITips.show(withText: "已删除")
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }else{
            CalendarManager.shared.deleteReminders(reminderModels: deleteEvents) {isSuccess  in
                QMUITips.hideAllTips()
                if isSuccess {
                    var tmpItemDatas = self.itemDatas
                    for (idx,itemData) in itemDatas.enumerated() {
                        if itemData.isSelected {
                            tmpItemDatas.remove(at: idx)
                        }
                    }
                    self.itemDatas = tmpItemDatas
                    QMUITips.show(withText: "已删除")
                    self.tableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func setupEmptyView() {
        showEmptyView(with: nil, text: "清理完毕，暂未可清理文件", detailText: nil, buttonTitle: "", buttonAction: nil)
        emptyView?.imageViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
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
        return UIImage.qmui_image(with: HEX("2373F5"))
    }
    
    override func navigationBarTintColor() -> UIColor? {
        return .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

extension DateOfOutCalendarVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dateOfOutCalendarCellID, for: indexPath) as! DateOfOutCalendarCell
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