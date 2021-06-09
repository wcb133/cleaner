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

class AllAnalyseVC: AppBaseVC {

    @IBOutlet weak var topView: UIView!
    
    var items:[AllAnalyseResultModel] = []
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
        tableView.register(UINib(nibName: "\(AllAnalyseCell.self)", bundle: nil), forCellReuseIdentifier: allScanCellID)
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
        lab.text = localizedString("Scanning")
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
    
    lazy var progressView:TXScanProgressView = {
        let w:CGFloat = 150
        let progressView = TXScanProgressView(frame: CGRect(x: (cScreenWidth - w) * 0.5, y: 20.0, width: w, height: w))
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
        titleView?.title = localizedString("Analyzing")
        self.deleteBtn.isHidden = true
        self.deleteBtnHeightCons.constant = 0
        deleteBtn.layer.cornerRadius = 24
        deleteBtn.layer.masksToBounds = true
        self.bottomInsetCons.constant = 20 + cIndicatorHeight
        self.percentLab.text = "0%"
        self.bottomTipsLab.backgroundColor = .clear
        let titles = [localizedString("Photo Clear"),localizedString("Address Book"),localizedString("Calendar"),localizedString("Video Clear")]
        for title in titles {
            let model = AllAnalyseResultModel()
            model.title = title
            self.items.append(model)
        }
        self.tableView.reloadData()
        //分析完成监听回调
        let sigOne = Observable.zip(self.photoVideoSubject, self.contactSubject, self.reminderSubject)
        sigOne.subscribe(onNext: {[weak self] (text) in
            guard let self = self else { return }
            self.titleView?.title = localizedString("Cleanable Files")
            
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
            self.startAllScanAction()
        }
    }
    
    func startAllScanAction()  {
        //联系人分析
        ContactAnalyseTool.shared.getAllRepeatContacts { [weak self] in
            guard let self = self else { return }
            let item = self.items[1]
            item.subTitle = "\(ContactAnalyseTool.shared.repeatContacts.count)" + localizedString(" duplicate contact")
            item.isDidCheck = true
            self.contactSubject.onNext("")
        }
        
        //过期提醒
        CalendarAnalyseTool.shared.getAllOutOfDateReminders {[weak self] reminders in
            guard let self = self else { return }
            let item = self.items[2]
            item.subTitle = "\(reminders.count)" + localizedString(" reminder")
            item.isDidCheck = true
            self.reminderSubject.onNext("")
        }
        
        let manager = ImageAndVideoAnalyseTool.shared
        manager.loadAllAsset {[weak  self] (currentIndex, total) in
            guard let self = self else { return }
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: {[weak self] (isSuccess, error) in
            guard let self = self else { return }
            let ImageModel = self.items[0]
            let videoModel = self.items[3]
            ImageModel.isDidCheck = true
            videoModel.isDidCheck = true
            if isSuccess {
                let photoNums = manager.similarArray.flatMap{$0.map{$0}}.count
                let videoNums = manager.similarVideos.flatMap{$0.map{$0}}.count
                ImageModel.subTitle = "\(photoNums)" + localizedString(" similar photos")
                videoModel.subTitle = "\(videoNums)"  + localizedString(" similar videos")
            }else{
                ImageModel.subTitle = "0" + localizedString(" similar photos")
                videoModel.subTitle = "0" + localizedString(" similar videos")
            }
            
            self.photoVideoSubject.onNext("")
        }
    }
    
    
    
    @IBAction func deleteBtnACtion(_ sender: QMUIButton) {
        
        if DateTool.shared.isExpired() {
            let vc = PurchaseServiceVC()
            let nav = AppBaseNav(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
            return
        }
        
        let message = localizedString("After the file is cleared, it cannot be recovered. Are you sure you want to clear all the selected files?")
        ImageAndVideoAnalyseTool.shared.tipWith(message: message) { [weak self]in
            guard let self = self else { return }
            let manager = ImageAndVideoAnalyseTool.shared
            var deleteAssets:[PHAsset] = []
            QMUITips.showLoading(in: self.view)
            for (idx,item) in self.items.enumerated() {
                if !item.isSelect { continue }
                if idx == 0 {
                    let similarArray = ImageAndVideoAnalyseTool.shared.similarArray.flatMap{$0.map{$0.asset}}
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
                        ContactAnalyseTool.shared.deleteSelectContacts(contacts: selectContactModels)
                    }
                }else if idx == 2{
                    if !self.reminders.isEmpty {
                        CalendarAnalyseTool.shared.deleteSelectReminders(reminderModels: self.reminders) {isSuccess  in
                            if isSuccess {
                                self.reminders = []
                            }
                        }
                    }
                }else{
                    let similarVideos = ImageAndVideoAnalyseTool.shared.similarVideos.flatMap{$0.map{$0.asset}}
                    deleteAssets.append(contentsOf: similarVideos)
                }
            }
            
             //清除相片和视频
             manager.deleteAsset(assets: deleteAssets) {[weak self] (isSuccess, error) in
                guard let self = self else { return }
                QMUITips.hideAllTips()
                if isSuccess {
                    let ImageModel = self.items[0]
                    let videoModel = self.items[3]
                    if ImageModel.isSelect {
                        manager.similarArray = []
                    }
                    if videoModel.isSelect {
                        manager.similarVideos = []
                    }
                    
                    let subTitles = ["0" + localizedString(" similar photos"),"0" + localizedString(" duplicate contact"),"0" + localizedString(" reminder"),"0" + localizedString(" similar videos")]
                    for (idx,item) in self.items.enumerated() {
                        item.subTitle = subTitles[idx]
                    }
                    self.tableView.reloadData()
                    self.refreshMemeryBlock()
                    QMUITips.show(withText: localizedString("Cleared Successfully"))
                }
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.isComplete {
            self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 16)
        }
        self.deleteBtn.addGradientLayer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        ImageAndVideoAnalyseTool.shared.isStopScan = true
    }
}

extension AllAnalyseVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: allScanCellID, for: indexPath) as! AllAnalyseCell
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
        let manager = ImageAndVideoAnalyseTool.shared
        switch indexPath.row {
        case 0://照片清理
            let vc = ImageAndVideoAnalyseVC()
            vc.refreshMemeryBlock = {
                let ImageModel = self.items[0]
                let photoNums = manager.similarArray.count
                ImageModel.subTitle = "\(photoNums)" + localizedString(" similar photos")
                self.refreshMemeryBlock()
            }
            vc.isScanPhoto = true
            vc.isComplete = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1://通讯录
            let vc = AddressBookManagerVC()
            vc.refreshUIBlock = {
                //联系人分析
                DispatchQueue.global().async {
                    ContactAnalyseTool.shared.getAllRepeatContacts {[weak self]  in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            let item = self.items[1]
                            item.subTitle = "\(ContactAnalyseTool.shared.repeatContacts.count)" + localizedString(" duplicate contact")
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 2://日历
            let vc = CalendarManagerVC()
            vc.setup()
            vc.refreshUIBlock = {
                DispatchQueue.global().async {
                    CalendarAnalyseTool.shared.getAllOutOfDateReminders {[weak self] reminders in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            let item = self.items[2]
                            item.subTitle = "\(reminders.count)" + localizedString(" reminder")
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 3://视频清理
            let vc = ImageAndVideoAnalyseVC()
            vc.refreshMemeryBlock = {
                let videoModel = self.items[3]
                let videoNums = manager.similarVideos.count
                videoModel.subTitle = "\(videoNums)" + localizedString(" similar videos")
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

