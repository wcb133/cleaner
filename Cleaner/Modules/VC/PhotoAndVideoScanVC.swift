//
//  PhotoAndVideoScanVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/22.
//

import UIKit
import QMUIKit
import SnapKit

class PhotoAndVideoScanVC: BaseVC {

    var items:[PhotoAndVideoScanModel] = []
    
    var isScanPhoto = true
    
    var tableTopOffetConstraint:Constraint?
    
    @IBOutlet weak var topView: UIView!
    lazy var tableContainerView:UIView = {
        let tableContainerView = UIView()
        tableContainerView.backgroundColor = .white
        self.view.addSubview(tableContainerView)
        tableContainerView.snp.makeConstraints { (m) in
            m.left.bottom.right.equalTo(0)
            self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-8).constraint
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
        tableView.register(UINib(nibName: "\(PhotoAndVideoScanCell.self)", bundle: nil), forCellReuseIdentifier: photoAndVideoScanCellID)
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
    
    lazy var progressView:TXUploadingProgressView = {
        let w:CGFloat = 150
        let progressView = TXUploadingProgressView(frame: CGRect(x: (cScreenWidth - w) * 0.5, y: 20.0, width: w, height: w))
        progressView.progress = 0.6
        self.topView.addSubview(progressView)
        return progressView
    }()
    
    let photoTitles = ["模糊照片","相似照片","屏幕截图","超大照片"]
    let videoTitles = ["重复视频","相似视频","损坏视频","超大视频"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = false
        titleView?.title = isScanPhoto ? "图片清理":"视频清理"
        titleView?.titleLabel.textColor = .white
        self.bottomTipsLab.textColor = .white
        
        
        //内存使用
        let usedSpace = MemoryManager.getUsedSpace()
        let totalSpace = MemoryManager.getTotalSpace()
        let freeSpace = totalSpace - usedSpace
        
        let memoryString = String(format: "剩余%.2fGB",freeSpace)
        let highLightString = String(format: "%.2f",freeSpace)
        self.memoryLab.attributedText = NSMutableAttributedString.highLightText(memoryString, highLight: highLightString, font: .systemFont(ofSize: 15), highLightFont: MediumFont(size: 38)!, color: .white, highLightColor: .white)
        
        self.memoryPercentLab.text = String(format: "已使用%.2f%%", usedSpace / totalSpace * 100)
        
        
        //从0开始
        self.percentLab.text = "0%"

        if isScanPhoto {
            let icons = ["提醒","提醒","提醒","提醒"]
            for (idx,icon) in icons.enumerated() {
                let model = PhotoAndVideoScanModel()
                model.title = photoTitles[idx]
                model.icon = icon
                self.items.append(model)
            }
        }else{
            let icons = ["提醒","提醒","提醒","提醒"]
            for (idx,icon) in icons.enumerated() {
                let model = PhotoAndVideoScanModel()
                model.title = videoTitles[idx]
                model.icon = icon
                self.items.append(model)
            }
        }

        self.tableView.reloadData()
        
        //获取数据
        DispatchQueue.main.async {
            if self.isScanPhoto {
                self.loadPhoto()
            }else{
                self.loadVideo()
            }
        }
    }
    
    
    func loadPhoto() {
        PhotoManager.shared.loadPhoto { (currentIndex, total) in
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: { (isSuccess, error) in
            print("成功？ ===== \(isSuccess)")
            self.bottomTipsLab.removeFromSuperview()
            self.progressView.removeFromSuperview()
            self.memoryLab.isHidden = false
            self.memoryPercentLab.isHidden = false
            
            self.tableTopOffetConstraint?.uninstall()
            self.tableContainerView.snp.makeConstraints { (m) in
                self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-100).constraint
            }
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            
            if isSuccess {
                let spaces:[Int] = [PhotoManager.shared.fuzzyPhotoSaveSpace,PhotoManager.shared.similarSaveSpace,PhotoManager.shared.screenshotsSaveSpace,PhotoManager.shared.thinPhotoSaveSpace]
                var similarCount:Int = 0
                for items in PhotoManager.shared.similarArray {
                    similarCount = similarCount + items.count
                }
                let nums:[Int] = [PhotoManager.shared.fuzzyPhotoArray.count,similarCount,PhotoManager.shared.screenshotsArray.count,PhotoManager.shared.thinPhotoArray.count]
                
                for (idx,item) in self.items.enumerated() {
                    item.subTitle = String(format: "%d张，%.2fMB", nums[idx],Float(spaces[idx])  / (1024 * 1024))
                    item.isDidCheck = true
                }
                self.tableView.reloadData()
            }else{
                for item in self.items {
                    item.subTitle = "0张，0.00MB"
                    item.isDidCheck = true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func loadVideo() {
        VideoManager.shared.loadVideo { (currentIndex, total) in
            let percent = Float(currentIndex) / Float(total)
            self.percentLab.text = String(format: "%.0f%%", percent * 100)
        } completionHandler: { (isSuccess, error) in
            print("成功？ ===== \(isSuccess)")
            self.bottomTipsLab.removeFromSuperview()
            self.progressView.removeFromSuperview()
            self.memoryLab.isHidden = false
            self.memoryPercentLab.isHidden = false
            self.tableTopOffetConstraint?.uninstall()
            self.tableContainerView.snp.makeConstraints { (m) in
                self.tableTopOffetConstraint = m.top.equalTo(self.topView.snp.bottom).offset(-100).constraint
            }
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
            if isSuccess {
                let videoM = VideoManager.shared
                let nums:[Int] = [videoM.sameVideoArray.count,videoM.similarVideos.count,videoM.badVideoArray.count,videoM.bigVideoArray.count]
                let spaces:[Float] = [videoM.sameVideoSpace,videoM.similarVideoSpace,videoM.badVideoSpace,videoM.bigVideoSpace]
                
                for (idx,item) in self.items.enumerated() {
                    item.subTitle = String(format: "%d个，%.2fMB", nums[idx],spaces[idx])
                    item.isDidCheck = true
                }
                self.tableView.reloadData()
            }else{
                for item in self.items {
                    item.subTitle = "0个，0.00MB"
                    item.isDidCheck = true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableContainerView.cornerWith(byRoundingCorners: [.topLeft,.topRight], radii: 8)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension PhotoAndVideoScanVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: photoAndVideoScanCellID, for: indexPath) as! PhotoAndVideoScanCell
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
            let allSimilarArray:[PhotoModel] = PhotoManager.shared.similarArray.flatMap { $0.map { $0 }}
            let images:[[PhotoModel]] = [PhotoManager.shared.fuzzyPhotoArray,allSimilarArray,PhotoManager.shared.screenshotsArray,PhotoManager.shared.thinPhotoArray]
            let vc = PhotoAndVideoClearVC()
            vc.isPhoto = true
            vc.titleString = self.photoTitles[indexPath.row]
            vc.items = images[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{//查看视频
            let videoM = VideoManager.shared
            
            let sameVideos = videoM.sameVideoArray.flatMap { $0.map { $0 }}
            let similarVideos = videoM.similarVideos.flatMap { $0.map { $0 }}
            
            let videoItems:[[VideoModel]] = [sameVideos,similarVideos,videoM.badVideoArray,videoM.bigVideoArray]
            let vc = PhotoAndVideoClearVC()
            vc.isPhoto = false
            vc.titleString = self.videoTitles[indexPath.row]
            vc.videoItems = videoItems[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

