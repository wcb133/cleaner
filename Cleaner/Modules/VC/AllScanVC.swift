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

class AllScanVC: BaseVC {

    @IBOutlet weak var topView: UIView!
    
    var items:[AllScanModel] = []
    var tableTopOffetConstraint:Constraint?
    
    @IBOutlet weak var bottomInsetCons: NSLayoutConstraint!
    
    @IBOutlet weak var deleteBtn: QMUIButton!
    
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
        tableView.rowHeight = 90
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
    
//    //图片分析完成信号
//    let hpotoSubject = PublishSubject<String>()
//    //视频分析完成信号
//    let videoSubject = PublishSubject<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView?.title = "优化中"
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
        DispatchQueue.main.async {
            //开始分析
            self.startAnalysis()
        }
    }
    
    func startAnalysis()  {
        let manager = PhotoAndVideoManager.shared
        manager.loadAllAsset { (currentIndex, total) in
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: { (isSuccess, error) in
            self.titleView?.title = "可清理的文件"
            
            self.tableTopOffetConstraint?.uninstall()
            self.tableContainerView.snp.makeConstraints { (m) in
                self.tableTopOffetConstraint = m.top.equalTo(0).constraint
            }
            
            UIView.animate(withDuration: 0.25) {
                self.bottomTipsLab.isHidden = true
                self.progressView.isHidden = true
                self.view.layoutIfNeeded()
            } completion: { (iSuccess) in
                self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 0)
                self.bottomTipsLab.removeFromSuperview()
                self.progressView.removeFromSuperview()
            }
            
            let photoModel = self.items[0]
            let videoModel = self.items[3]
            photoModel.isDidCheck = true
            videoModel.isDidCheck = true
            if isSuccess {
                let photoNums = manager.similarArray.count + manager.fuzzyPhotoArray.count + manager.screenshotsArray.count + manager.thinPhotoArray.count
                let videoNums = manager.similarVideos.count + manager.sameVideoArray.count + manager.badVideoArray.count + manager.bigVideoArray.count
                photoModel.subTitle = "可清理照片\(photoNums)张"
                videoModel.subTitle = "可清理视频\(videoNums)张"
            }else{
                photoModel.subTitle = "暂无可优化项"
                videoModel.subTitle = "暂无可优化项"
            }
            self.tableView.reloadData()
            self.isComplete = true
            
        }
        
        //联系人分析
        ContactManager.shared.getRepeatContact { (contactSectonModels, total) in
            let item = self.items[1]
            item.subTitle = "\(contactSectonModels.count)个重复联系人"
            item.isDidCheck = true
        }
        
        //过期提醒
        CalendarManager.shared.getOutOfDateReminder { reminders in
            let item = self.items[2]
            item.subTitle = "\(reminders.count)个提醒"
            item.isDidCheck = true
        }
    }
    
    @IBAction func deleteBtnACtion(_ sender: QMUIButton) {
        
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
        switch indexPath.row {
        case 0:
            let vc = PhotoAndVideoScanVC()
            vc.isScanPhoto = true
            vc.isComplete = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.navigationController?.pushViewController(ContactVC(), animated: true)
        case 2:
            self.navigationController?.pushViewController(CalendarMainVC(), animated: true)
        case 3:
            let vc = PhotoAndVideoScanVC()
            vc.isScanPhoto = false
            vc.isComplete = true
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

