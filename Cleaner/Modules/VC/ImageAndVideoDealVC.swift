//
//  PhotoAndVideoClearVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit
import QMUIKit
import AVKit
import RxSwift
import RxCocoa

class ImageAndVideoDealVC: AppBaseVC {
    
    //图片时
    var items:[ImageModel] = []
    //视频时
    var videoItems:[VideoModel] = []
    
    var isPhoto = true
    //上一界面传入
    var  index:Int = 0
    //标题
    var titleString = ""
    
    var refreshMemeryBlock:()->Void = {}
    
    lazy var deleteBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.addTarget(self, action: #selector(deleteBtnAction(btn:)), for: .touchUpInside)
        btn.setTitle("删除选中", for: .normal)
        btn.backgroundColor = HEX("28B3FF")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.left.equalTo(25)
            m.right.equalTo(-25)
            m.height.equalTo(48)
            m.bottom.equalTo(-20-cIndicatorHeight)
        }
        return btn
    }()

    lazy var colltionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        let w:CGFloat = (cScreenWidth - 15) / 3
        layout.itemSize = CGSize(width: w, height: w)
        let colltionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        colltionView.register(UINib(nibName: "\(ImageAndVideoDealCell.self)", bundle: nil), forCellWithReuseIdentifier: photoAndVideoClearCellID)
        
        colltionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        colltionView.delegate = self;
        colltionView.dataSource = self;
        colltionView.showsVerticalScrollIndicator = false
        colltionView.showsHorizontalScrollIndicator = false
        colltionView.backgroundColor = .white
        
        self.view.addSubview(colltionView)
        colltionView.snp.makeConstraints { (m) in
            m.left.right.equalTo(0)
            m.top.equalTo(0)
            m.bottom.equalTo(self.deleteBtn.snp.top).offset(-15)
        }
        return colltionView
    }()
    
    lazy var playerController: AVPlayerViewController = {
        let playerController = AVPlayerViewController()
        playerController.allowsPictureInPicturePlayback = true
        return playerController
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.setTitle("全选", for: .normal)
        rightBtn.setTitleColor(HEX("FDCC33"), for: .normal)
        rightBtn.addTarget(self, action: #selector(rightBtnAction(btn:)), for: .touchUpInside)
        rightBtn.qmui_height = 44
        rightBtn.qmui_width = 75
        rightBtn.contentHorizontalAlignment = .right
        rightBtn.titleLabel?.font = MediumFont(size: 17)
        return rightBtn
    }()
    
    @objc dynamic var selectNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyView()
        titleView?.title = titleString
        colltionView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        
        self.rx.observeWeakly(Int.self, "selectNum").asObservable().subscribe(onNext: { [weak self] num in
            guard let self = self else { return }
            if self.isPhoto {
                if num == self.items.count {
                    self.rightBtn.setTitle("取消全选", for: .normal)
                }else{
                    self.rightBtn.setTitle("全选", for: .normal)
                }
            }else{
                if num == self.videoItems.count {
                    self.rightBtn.setTitle("取消全选", for: .normal)
                }else{
                    self.rightBtn.setTitle("全选", for: .normal)
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        
   
        if isPhoto {
            if self.items.isEmpty {
                showEmptyView()
                self.deleteBtn.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
            
            for item in self.items {
                if item.isSelect {
                    selectNum += 1
                }
            }
        }else{
            if self.videoItems.isEmpty {
                showEmptyView()
                self.deleteBtn.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
            for item in self.videoItems {
                if item.isSelect {
                    selectNum += 1
                }
            }
        }
        
    }
    
    @objc  func rightBtnAction(btn:UIButton)  {
        let titleString = btn.currentTitle ?? ""
        if titleString == "全选" {
            self.selectNum = isPhoto ? self.items.count:self.videoItems.count
            if isPhoto {
                self.items.forEach { model in
                    model.isSelect = true
                }
            }else{
                self.videoItems.forEach { model in
                    model.isSelect = true
                }
            }
            self.colltionView.reloadData()
        }else{
            self.selectNum = 0
            if isPhoto {
                self.items.forEach { model in
                    model.isSelect = false
                }
            }else{
                self.videoItems.forEach { model in
                    model.isSelect = false
                }
            }
            self.colltionView.reloadData()
        }
    }
    
    @objc func deleteBtnAction(btn:QMUIButton) {
        
        if DateTool.shared.isExpired() {
            let vc = PurchaseServiceVC()
            let nav = AppBaseNav(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
            return
        }
        
        
        let message = self.isPhoto ? "删除后将无法恢复，确定删除选中的照片？":"删除后将无法恢复，确定删除选中的视频？"
        ImageAndVideoAnalyseTool.shared.tipWith(message: message) {[weak self] in
            guard let self = self else { return }
            self.isPhoto ? self.deletePhotos():self.deleteSelectVideos()
        }
    }
    
    func deletePhotos()  {
        var selectItems:[ImageModel] = []
        var deleteAssets:[PHAsset] = []
        for item in items {
            if item.isSelect {
                selectItems.append(item)
                deleteAssets.append(item.asset)
            }
        }
        
        if selectItems.isEmpty {
            QMUITips.show(withText: "请勾选要删除的图片")
            return
        }
        let manager = ImageAndVideoAnalyseTool.shared
        QMUITips.showLoading(in: self.navigationController!.view)
        manager.deleteAsset(assets: deleteAssets) {[weak self] (isSuccess, error) in
            guard let self = self else { return }
            QMUITips.hideAllTips()
            if isSuccess {
                //移除数据源
                self.items.removeAll { imageModel -> Bool in
                    return imageModel.isSelect
                }
                
                if self.index == 0 {
                    manager.fuzzyPhotoArray.removeAll { imageModel -> Bool in
                        return imageModel.isSelect
                    }
                }else if self.index == 1 {
                    for (idx,similars) in manager.similarArray.enumerated() {
                        var tmpSimilars = similars
                        tmpSimilars.removeAll { imageModel -> Bool in
                            return imageModel.isSelect
                        }
                        
                        manager.similarArray.remove(at: idx)
                        manager.similarArray.insert(tmpSimilars, at: idx)
                        //移除空的
                        manager.similarArray.removeAll { (array) -> Bool in
                            return array.isEmpty
                        }
                    }
                    
                } else if self.index == 2 {
                    manager.screenshotsArray.removeAll { imageModel -> Bool in
                        return imageModel.isSelect
                    }
                }else if self.index == 3 {
                    manager.thinPhotoArray.removeAll { imageModel -> Bool in
                        return imageModel.isSelect
                    }
                }
    
                
                self.colltionView.reloadData()
                QMUITips.show(withText: "已删除")
                self.refreshMemeryBlock()
                if self.items.isEmpty {
                    self.showEmptyView()
                    self.deleteBtn.isHidden = true
                }
            }
        }
    }
    func deleteSelectVideos()  {
        var selectItems:[VideoModel] = []
        var deleteAssets:[PHAsset] = []
        for item in videoItems {
            if item.isSelect {
                selectItems.append(item)
                deleteAssets.append(item.asset)
            }
        }
        
        if selectItems.isEmpty {
            QMUITips.show(withText: "请勾选要删除的视频")
            return
        }
        QMUITips.showLoading(in: self.navigationController!.view)
        let manager = ImageAndVideoAnalyseTool.shared
        manager.deleteAsset(assets: deleteAssets) { [weak self] (isSuccess, error) in
            guard let self = self else { return }
            QMUITips.hideAllTips()
            if isSuccess {
                //移除数据源
                self.videoItems.removeAll { videoModel -> Bool in
                    return videoModel.isSelect
                }
                
                if self.index == 0 {
                    
                    for (idx,sameVideos) in manager.sameVideoArray.enumerated() {
                        var tmpSameVideos = sameVideos
                        tmpSameVideos.removeAll { videoModel -> Bool in
                            return videoModel.isSelect
                        }
                        manager.sameVideoArray.remove(at: idx)
                        manager.sameVideoArray.insert(tmpSameVideos, at: idx)
                        //移除空的
                        manager.sameVideoArray.removeAll { (array) -> Bool in
                            return array.isEmpty
                        }
                    }
                }else if self.index == 1 {
                    for (idx,similars) in manager.similarVideos.enumerated() {
                        var tmpSimilars = similars
                        tmpSimilars.removeAll { videoModel -> Bool in
                            return videoModel.isSelect
                        }
                        
                        manager.similarVideos.remove(at: idx)
                        manager.similarVideos.insert(tmpSimilars, at: idx)
                        //移除空的
                        manager.similarVideos.removeAll { (array) -> Bool in
                            return array.isEmpty
                        }
                    }
                    
                } else if self.index == 2 {
                    manager.badVideoArray.removeAll { imageModel -> Bool in
                        return imageModel.isSelect
                    }
                }else if self.index == 3 {
                    manager.bigVideoArray.removeAll { imageModel -> Bool in
                        return imageModel.isSelect
                    }
                }
            
                self.colltionView.reloadData()
                QMUITips.show(withText: "已删除")
                self.refreshMemeryBlock()
                if self.videoItems.isEmpty {
                    self.showEmptyView()
                    self.deleteBtn.isHidden = true
                }
            }
        }
    }
    
    func setupEmptyView() {
        showEmptyView(with: UIImage(named: "无内容"), text: "未发现可清理项", detailText: nil, buttonTitle: "", buttonAction: nil)
        emptyView?.imageViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
        emptyView?.textLabelFont = .systemFont(ofSize: 14)
        emptyView?.textLabelTextColor = HEX("#7C8A9C")
        emptyView?.verticalOffset = 0
        hideEmptyView()
    }
    
    override func showEmptyView() {
        if emptyView == nil {
            emptyView = QMUIEmptyView(frame: colltionView.bounds)
        }
        colltionView.addSubview(emptyView!)
        emptyView?.frame = CGRect(x: 0, y: 0, width: cScreenWidth, height: colltionView.qmui_height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyView?.frame = CGRect(x: 0, y: 0, width: cScreenWidth, height: colltionView.qmui_height)
    }
}


extension ImageAndVideoDealVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  isPhoto ? items.count:videoItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAndVideoClearCellID, for: indexPath) as! ImageAndVideoDealCell
        cell.selectBtnActionBlock = { [weak self] in
            guard let self  = self else { return }
            if self.isPhoto {
                let model = self.items[indexPath.row]
                model.isSelect = !model.isSelect
                collectionView.reloadItems(at: [indexPath])
                if model.isSelect {
                    self.selectNum += 1
                }else{
                    self.selectNum -= 1
                }
            }else{
                let model = self.videoItems[indexPath.row]
                model.isSelect = !model.isSelect
                collectionView.reloadItems(at: [indexPath])
                if model.isSelect {
                    self.selectNum += 1
                }else{
                    self.selectNum -= 1
                }
            }
            
        }
        if isPhoto {
            cell.item = items[indexPath.row]
        }else{
            cell.videoItem = videoItems[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPhoto {
            let model = self.items[indexPath.row]
            let vc = ImagePreviewVC()
            vc.image = model.exactImage
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
//            if self.presentedViewController != nil { return }
            let model = self.videoItems[indexPath.row]
            let playerItem = AVPlayerItem(asset: model.videoAsset)
            let player = AVPlayer(playerItem: playerItem)
            self.playerController.player = player
            self.navigationController?.present(self.playerController, animated: true, completion: nil)
            self.playerController.player?.play()

            
        }
        
    }
}
