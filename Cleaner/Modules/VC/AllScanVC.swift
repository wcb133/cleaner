//
//  AllScanVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/23.
//

import UIKit
import SnapKit
import QMUIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class AllScanVC: BaseVC {

    @IBOutlet weak var topView: UIView!
    
    var items:[AllScanModel] = []
    var contactSectonModels:[ContactSectonModel] = []
    var reminders:[CalendarEventModel] = []
    var tableTopOffetConstraint:Constraint?
    
    @IBOutlet weak var bottomInsetCons: NSLayoutConstraint!
    
    @IBOutlet weak var deleteBtnHeightCons: NSLayoutConstraint!
    @IBOutlet weak var deleteBtn: QMUIButton!
    
    var refreshMemeryBlock:()->Void = {}
    
    //是否分析完成
    var isComplete = false
    
    lazy var tableContainerView:UIView = {
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = .white
        self.view.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.bottom.equalTo(self.deleteBtn.snp.top).offset(-12)
            self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-16).constraint
        }
        return tableContainerView
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = iPhoneX ? 90:84
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor =  .white
        tableView.register(UINib(nibName: "\(AllScanCell.self)", bundle: nil), forCellReuseIdentifier: allScanCellID)
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
    
    lazy var circleView: UIView = {
        let w = progressView.qmui_width - 40
        let circleView = UIView()
        circleView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        circleView.layer.cornerRadius = w * 0.5
        circleView.layer.borderWidth = 2
        circleView.layer.borderColor = UIColor.white.cgColor
        self.progressView.addSubview(circleView)
        circleView.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.height.equalTo(w)
        }
        return circleView
    }()
    
    lazy var percentLab:UILabel = {
        let lab = UILabel()
        lab.text = "0%"
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 30)
        lab.textAlignment = .center
        self.circleView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
        }
        return lab
    }()
    
    lazy var bottomTipsLab:UILabel = {
        let lab = UILabel()
        lab.text = "努力分析中"
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 16)
        lab.textAlignment = .center
        self.topView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(self.progressView.snp.bottom).offset(20)
        }
        return lab
    }()
    
    lazy var progressView:TXUploadingProgressView = {
        let w:CGFloat = 150
        let progressView = TXUploadingProgressView(frame: CGRect(x: (cScreenWidth - w) * 0.5, y: 20.0, width: w, height: w))
        progressView.progress = 0.6
        self.topView.addSubview(progressView)
        return progressView
    }()
    
    //图片分析完成信号
    let photoVideoSubject = PublishSubject<String>()
    //联系人分析完成信号
    let contactSubject = PublishSubject<String>()
    //联系人分析完成信号
    let reminderSubject = PublishSubject<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView?.title = "分析中"
        self.deleteBtn.isHidden = true
        self.deleteBtnHeightCons.constant = 0
        deleteBtn.layer.cornerRadius = 24
        deleteBtn.layer.masksToBounds = true
        self.bottomInsetCons.constant = 20 + cIndicatorHeight
        self.percentLab.text = "0%"
        self.bottomTipsLab.backgroundColor = .clear
        let titles = ["照片清理","通讯录优化","日历及提醒","视频清理"]
        for title in titles {
            let model = AllScanModel()
            model.title = title
            self.items.append(model)
        }
        self.tableView.reloadData()
        //分析完成监听回调
        let sigOne = Observable.zip(self.photoVideoSubject, self.contactSubject, self.reminderSubject)
        sigOne.subscribe(onNext: {[weak self] (text) in
            guard let self = self else { return }
            self.titleView?.title = "可清理的文件"
            
            self.tableTopOffetConstraint?.uninstall()
            self.tableContainerView.snp.makeConstraints { (m) in
                self.tableTopOffetConstraint = m.top.equalTo(0).constraint
            }
            
            UIView.animate(withDuration: 0.25) {
                self.deleteBtn.isHidden = false
                self.bottomTipsLab.isHidden = true
                self.progressView.isHidden = true
                self.view.layoutIfNeeded()
            } completion: { (iSuccess) in
                self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 0)
                self.bottomTipsLab.removeFromSuperview()
                self.progressView.removeFromSuperview()
            }
            self.deleteBtnHeightCons.constant = 48
            self.tableView.reloadData()
            self.isComplete = true
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        //开始分析
        DispatchQueue.main.async {
            self.startAnalysis()
        }
    }
    
    func startAnalysis()  {
        let manager = PhotoAndVideoManager.shared
        manager.loadAllAsset {[weak  self] (currentIndex, total) in
            guard let self = self else { return }
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: {[weak self] (isSuccess, error) in
            guard let self = self else { return }
            let photoModel = self.items[0]
            let videoModel = self.items[3]
            photoModel.isDidCheck = true
            videoModel.isDidCheck = true
            if isSuccess {
                let photoNums = manager.similarArray.count
                let videoNums = manager.similarVideos.count
                photoModel.subTitle = "\(photoNums)张相似照片"
                videoModel.subTitle = "\(videoNums)个相似视频"
            }else{
                photoModel.subTitle = "0张相似照片"
                videoModel.subTitle = "0个相似视频"
            }
            
            self.photoVideoSubject.onNext("")
        }
        
        //联系人分析
        ContactManager.shared.getRepeatContact {[weak self] (contactSectonModels, total) in
            guard let self = self else { return }
            let item = self.items[1]
            item.subTitle = "\(contactSectonModels.count)个重复联系人"
            item.isDidCheck = true
            self.contactSubject.onNext("")
        }
        
        //过期提醒
        CalendarManager.shared.getOutOfDateReminder {[weak self] reminders in
            guard let self = self else { return }
            let item = self.items[2]
            item.subTitle = "\(reminders.count)个提醒"
            item.isDidCheck = true
            self.reminderSubject.onNext("")
        }
    }
    
    
    
    @IBAction func deleteBtnACtion(_ sender: QMUIButton) {
        
//        if DateManager.shared.isExpired() {
//            let vc = SubscribeVC()
//            vc.modalPresentationStyle = .fullScreen
//            self.navigationController?.present(vc, animated: true, completion: nil)
//            return
//        }
        
        let message = "文件清除后将无法恢复，确定清除选中的所有文件?"
        PhotoAndVideoManager.shared.tipWith(message: message) { [weak self]in
            guard let self = self else { return }
            let manager = PhotoAndVideoManager.shared
            var deleteAssets:[PHAsset] = []
            QMUITips.showLoading(in: self.view)
            for (idx,item) in self.items.enumerated() {
                if !item.isSelect { continue }
                if idx == 0 {
                    let similarArray = PhotoAndVideoManager.shared.similarArray.flatMap{$0.map{$0.asset}}
                    deleteAssets.append(contentsOf: similarArray)
                }else if idx == 1{//删除联系人
                    var selectContactModels:[ContactModel] = []
                    for contactSectonModel in self.contactSectonModels {
                        for model in contactSectonModel.contactModels {
                            if model.isSelected {
                                selectContactModels.append(model)
                            }
                        }
                    }
                    if !selectContactModels.isEmpty {
                        self.contactSectonModels = []
                        ContactManager.shared.deleteContacts(contacts: selectContactModels)
                    }
                }else if idx == 2{
                    if !self.reminders.isEmpty {
                        CalendarManager.shared.deleteReminders(reminderModels: self.reminders) {isSuccess  in
                            if isSuccess {
                                self.reminders = []
                            }
                        }
                    }
                }else{
                    let similarVideos = PhotoAndVideoManager.shared.similarVideos.flatMap{$0.map{$0.asset}}
                    deleteAssets.append(contentsOf: similarVideos)
                }
            }
            
             //清除相片和视频
             manager.deleteAsset(assets: deleteAssets) {[weak self] (isSuccess, error) in
                guard let self = self else { return }
                QMUITips.hideAllTips()
                if isSuccess {
                    let photoModel = self.items[0]
                    let videoModel = self.items[3]
                    if photoModel.isSelect {
                        manager.similarArray = []
                    }
                    if videoModel.isSelect {
                        manager.similarVideos = []
                    }
                    
                    let subTitles = ["0张相似照片","0个重复联系人","0个提醒","0个相似视频"]
                    for (idx,item) in self.items.enumerated() {
                        item.subTitle = subTitles[idx]
                    }
                    self.tableView.reloadData()
                    self.refreshMemeryBlock()
                    QMUITips.show(withText: "清除成功")
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.isComplete {
            self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 16)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        PhotoAndVideoManager.shared.isStopScan = true
    }
}

extension AllScanVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: allScanCellID, for: indexPath) as! AllScanCell
        let dataModel = items[indexPath.row]
        cell.dataModel = dataModel
        cell.selectBtnClickBlock = {
            dataModel.isSelect = !dataModel.isSelect
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = items[indexPath.row]
        if !model.isDidCheck { return }//未分析完，不可点击
        let manager = PhotoAndVideoManager.shared
        switch indexPath.row {
        case 0://照片清理
            let vc = PhotoAndVideoScanVC()
            vc.refreshMemeryBlock = {
                let photoModel = self.items[0]
                let photoNums = manager.similarArray.count
                photoModel.subTitle = "\(photoNums)张相似照片"
                self.refreshMemeryBlock()
            }
            vc.isScanPhoto = true
            vc.isComplete = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1://通讯录
            let vc = ContactVC()
            vc.refreshUIBlock = {
                //联系人分析
                DispatchQueue.global().async {
                    ContactManager.shared.getRepeatContact {[weak self] (contactSectonModels, total) in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            let item = self.items[1]
                            item.subTitle = "\(contactSectonModels.count)个重复联系人"
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 2://日历
            let vc = CalendarMainVC()
            vc.refreshUIBlock = {
                DispatchQueue.global().async {
                    CalendarManager.shared.getOutOfDateReminder {[weak self] reminders in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            let item = self.items[2]
                            item.subTitle = "\(reminders.count)个提醒"
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 3://视频清理
            let vc = PhotoAndVideoScanVC()
            vc.refreshMemeryBlock = {
                let videoModel = self.items[3]
                let videoNums = manager.similarVideos.count
                videoModel.subTitle = "\(videoNums)个相似视频"
                self.refreshMemeryBlock()
            }
            vc.isScanPhoto = false
            vc.isComplete = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

