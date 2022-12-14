//
//  PhotoAndVideoScanVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/22.
//

import UIKit
import QMUIKit
import SnapKit

class ImageAndVideoAnalyseVC: AppBaseVC {

    var items:[ImageAndVideoAnalyseModel] = []
    
    var isScanPhoto = true
    
    //是否完成分析
    var isComplete = false
    
    var refreshMemeryBlock:()->Void = {}
    
    var tableTopOffetConstraint:Constraint?
    @IBOutlet weak var topView: UIView!
    lazy var tableContainerView:UIView = {
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = .white
        self.view.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { (m) in
            m.left.bottom.right.equalTo(0)
            self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-16).constraint
        }
        return tableContainerView
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.rowHeight = 65
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.backgroundColor =  .white
        tableView.register(UINib(nibName: "\(ImageAndVideoAnalyseCell.self)", bundle: nil), forCellReuseIdentifier: photoAndVideoScanCellID)
        tableView.separatorColor = HEX("#E8E9EA")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
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
    
    lazy var memoryLab:UILabel = {
        let lab = UILabel()
        lab.isHidden = true
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 14)
        lab.textAlignment = .center
        self.topView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(30)
        }
        return lab
    }()
    
    lazy var memoryPercentLab:UILabel = {
        let lab = UILabel()
        lab.isHidden = true
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 16)
        lab.textAlignment = .center
        self.topView.addSubview(lab)
        lab.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.top.equalTo(self.memoryLab.snp.bottom).offset(8)
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
    
    let photoTitles = ["Blurred Photos","Similar Photos","Screen Capture","Oversized Photos"]
    let videoTitles = ["Repeated Video","Similar Videos","Damaged Videos","Oversized Videos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = false
        titleView?.title = isScanPhoto ? localizedString("Photo Clear"):localizedString("Video Clear")
        titleView?.titleLabel.textColor = .white
        self.bottomTipsLab.textColor = .white
        
        
        self.reloadMemeryDataAction()
        
        
        //从0开始
        self.percentLab.text = "0%"

        if isScanPhoto {
            let icons = ["模糊照片_icon","相似照片_icon","屏幕截图_icon","超大图片_icon"]
            for (idx,icon) in icons.enumerated() {
                let model = ImageAndVideoAnalyseModel()
                model.title = photoTitles[idx]
                model.icon = icon
                self.items.append(model)
            }
        }else{
            let icons = ["重复视频_icon","相似视频_icon","损坏视频_icon","超大视频_icon"]
            for (idx,icon) in icons.enumerated() {
                let model = ImageAndVideoAnalyseModel()
                model.title = videoTitles[idx]
                model.icon = icon
                self.items.append(model)
            }
        }

        self.tableView.reloadData()
        
        //获取数据
        if isComplete {//在外部已经获取好了数据
            if self.isScanPhoto  {
                self.refreshPhotoUI(isSuccess: true, animate: false)
            }else{
                self.refreshVideoUI(isSuccess: true, animate: false)
            }
        }else{
            DispatchQueue.main.async {
                if self.isScanPhoto {
                    self.loadAndAnalysePhoto()
                }else{
                    self.loadVideo()
                }
            }
        }
    }
    
    func reloadMemeryDataAction() {
        //内存使用
        let usedSpace = MemoryAnalyseTool.getUsedSpace()
        let totalSpace = MemoryAnalyseTool.getTotalSpace()
        let freeSpace = totalSpace - usedSpace
        
        let memoryString = String(format: "%@ %.2fGB",localizedString("Free"),freeSpace)
        let highLightString = String(format: "%.2f",freeSpace)
        self.memoryLab.attributedText = NSMutableAttributedString.highText(memoryString, highLight: highLightString, font: .systemFont(ofSize: 15), highLightFont: MediumFont(size: 38)!, color: .white, highLightColor: .white)
        
        self.memoryPercentLab.text = String(format: "%@ %.2f%%", localizedString("Used"),usedSpace / totalSpace * 100)
    }
    
    
    func loadAndAnalysePhoto() {
        let manager = ImageAndVideoAnalyseTool.shared
        manager.loadAndAnalysePhoto {[weak self] (currentIndex, total) in
            guard let self = self else { return }
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: {[weak self] (isSuccess, error) in
            guard let self = self else { return }
            print("成功？ ===== \(isSuccess)")
            self.refreshPhotoUI(isSuccess: isSuccess,animate:true)
        }
    }
    
    //刷新UI
    func refreshPhotoUI(isSuccess:Bool,animate:Bool) {
        self.bottomTipsLab.removeFromSuperview()
        self.progressView.removeFromSuperview()
        self.memoryLab.isHidden = false
        self.memoryPercentLab.isHidden = false
        
        self.tableTopOffetConstraint?.uninstall()
        self.tableContainerView.snp.makeConstraints { (m) in
            self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-100).constraint
        }
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        
        if isSuccess {
            let spaces:[Int] = [ImageAndVideoAnalyseTool.shared.fuzzyPhotoSaveSpace,ImageAndVideoAnalyseTool.shared.similarSaveSpace,ImageAndVideoAnalyseTool.shared.screenshotsSaveSpace,ImageAndVideoAnalyseTool.shared.thinPhotoSaveSpace]
            var similarCount:Int = 0
            for items in ImageAndVideoAnalyseTool.shared.similarArray {
                similarCount = similarCount + items.count
            }
            let nums:[Int] = [ImageAndVideoAnalyseTool.shared.fuzzyPhotoArray.count,similarCount,ImageAndVideoAnalyseTool.shared.screenshotsArray.count,ImageAndVideoAnalyseTool.shared.thinPhotoArray.count]
            
            for (idx,item) in self.items.enumerated() {
                item.subTitle = String(format: "%d %@，%@ %.2fMB", nums[idx],localizedString("Picture"),localizedString("Total Occupancy"),Float(spaces[idx])  / (1024 * 1024))
                item.isDidCheck = true
            }
            self.tableView.reloadData()
        }else{
            for item in self.items {
                item.subTitle = String(format: "0 %@，%@ 0.00MB",localizedString("Picture"), localizedString("Total Occupancy"))
                item.isDidCheck = true
            }
            self.tableView.reloadData()
        }
    }
    
    
    
    func loadVideo() {
        let manager = ImageAndVideoAnalyseTool.shared
        manager.isStopScan = false
        manager.loadVideo { (currentIndex, total) in
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: { (isSuccess, error) in
            self.refreshVideoUI(isSuccess: isSuccess,animate:true)
        }
    }
    
    //刷新UI
    func refreshVideoUI(isSuccess:Bool,animate:Bool){
        self.bottomTipsLab.removeFromSuperview()
        self.progressView.removeFromSuperview()
        self.memoryLab.isHidden = false
        self.memoryPercentLab.isHidden = false
        self.tableTopOffetConstraint?.uninstall()
        self.tableContainerView.snp.makeConstraints { (m) in
            self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-100).constraint
        }
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        if isSuccess {
            let videoM = ImageAndVideoAnalyseTool.shared
            
            var similarCount:Int = 0
            for items in ImageAndVideoAnalyseTool.shared.similarVideos {
                similarCount = similarCount + items.count
                
            }
            
            var sameCount:Int = 0
            for items in ImageAndVideoAnalyseTool.shared.sameVideoArray {
                sameCount = sameCount + items.count
                
            }
            
            let nums:[Int] = [sameCount,similarCount,videoM.badVideoArray.count,videoM.bigVideoArray.count]
            let spaces:[Float] = [videoM.sameVideoSpace,videoM.similarVideoSpace,videoM.badVideoSpace,videoM.bigVideoSpace]
            
            for (idx,item) in self.items.enumerated() {
                item.subTitle = String(format: "%d %@，%@ %.2fMB", nums[idx],localizedString("Video"),localizedString("Total Occupancy"),spaces[idx])
                item.isDidCheck = true
            }
            self.tableView.reloadData()
        }else{
            for item in self.items {
                item.subTitle = String(format: "0 %@，%@ 0.00MB",localizedString("Video"), localizedString("Total Occupancy"))
                item.isDidCheck = true
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 16)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ImageAndVideoAnalyseVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: photoAndVideoScanCellID, for: indexPath) as! ImageAndVideoAnalyseCell
        cell.dataModel = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = items[indexPath.row]
        if !model.isDidCheck { return }//未分析完，不可点击
        
        if isScanPhoto {//查看照片
            let allSimilarArray:[ImageModel] = ImageAndVideoAnalyseTool.shared.similarArray.flatMap { $0.map { $0 }}
            let images:[[ImageModel]] = [ImageAndVideoAnalyseTool.shared.fuzzyPhotoArray,allSimilarArray,ImageAndVideoAnalyseTool.shared.screenshotsArray,ImageAndVideoAnalyseTool.shared.thinPhotoArray]
            let vc = ImageAndVideoDealVC()
            vc.refreshMemeryBlock = {
                self.reloadMemeryDataAction()
                self.refreshMemeryBlock()
                self.refreshPhotoUI(isSuccess: true, animate: false)
            }
            vc.isPhoto = true
            vc.index = indexPath.row
            vc.titleString = localizedString(self.photoTitles[indexPath.row])
            vc.items = images[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{//查看视频
            let videoM = ImageAndVideoAnalyseTool.shared
            
            let sameVideos = videoM.sameVideoArray.flatMap { $0.map { $0 }}
            let similarVideos = videoM.similarVideos.flatMap { $0.map { $0 }}
            
            let videoItems:[[VideoModel]] = [sameVideos,similarVideos,videoM.badVideoArray,videoM.bigVideoArray]
            let vc = ImageAndVideoDealVC()
            vc.isPhoto = false
            vc.index = indexPath.row
            vc.titleString = localizedString(self.videoTitles[indexPath.row])
            vc.videoItems = videoItems[indexPath.row]
            vc.refreshMemeryBlock = {
                self.reloadMemeryDataAction()
                self.refreshMemeryBlock()
                self.refreshVideoUI(isSuccess: true, animate: false)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

