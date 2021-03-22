//
//  PhotoAndVideoClearVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit
import QMUIKit

class PhotoAndVideoClearVC: BaseVC {
    
    //图片时
    var items:[PhotoModel] = []
    //视频时
    var videoItems:[VideoModel] = []
    
    var isPhoto = true
    //标题
    var titleString = ""
    
    lazy var deleteBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.addTarget(self, action: #selector(deleteBtnAction(btn:)), for: .touchUpInside)
        btn.setTitle("删除选中", for: .normal)
        btn.backgroundColor = HEX("3EB769")
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
        colltionView.register(UINib(nibName: "\(PhotoAndVideoClearCell.self)", bundle: nil), forCellWithReuseIdentifier: photoAndVideoClearCellID)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyView()
        titleView?.title = titleString
        colltionView.reloadData()
        
        if isPhoto {
            if self.items.isEmpty {
                showEmptyView()
                self.deleteBtn.isHidden = true
            }
        }else{
            if self.videoItems.isEmpty {
                showEmptyView()
                self.deleteBtn.isHidden = true
            }
        }
        
    }
    
    @objc func deleteBtnAction(btn:QMUIButton) {
        self.isPhoto ? deletePhotos():deleteVideos()
    }
    
    func deletePhotos()  {
        var selectItems:[PhotoModel] = []
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
        QMUITips.showLoading(in: self.navigationController!.view)
        PhotoManager.shared.deleteAsset(assets: deleteAssets) { (isSuccess, error) in
            QMUITips.hideAllTips()
            if isSuccess {
                //移除数据源
                var itemModels = self.items
                for (idx,item) in self.items.enumerated() {
                    if item.isSelect {
                        itemModels.remove(at: idx)
                    }
                }
                self.items = itemModels
                self.colltionView.reloadData()
                QMUITips.show(withText: "已删除")
                if self.items.isEmpty {
                    self.showEmptyView()
                    self.deleteBtn.isHidden = true
                }
            }
        }
    }
    func deleteVideos()  {
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

        VideoManager.shared.deleteAsset(assets: deleteAssets) { (isSuccess, error) in
            QMUITips.hideAllTips()
            if isSuccess {
                //移除数据源
                var itemModels = self.videoItems
                for (idx,item) in self.videoItems.enumerated() {
                    if item.isSelect {
                        itemModels.remove(at: idx)
                    }
                }
                self.videoItems = itemModels
                self.colltionView.reloadData()
                QMUITips.show(withText: "已删除")
                if self.videoItems.isEmpty {
                    self.showEmptyView()
                    self.deleteBtn.isHidden = true
                }
            }
        }
    }
    
    func setupEmptyView() {
        showEmptyView(with: nil, text: "清理完毕，暂未发现可清理项", detailText: nil, buttonTitle: "", buttonAction: nil)
        emptyView?.imageViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
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


extension PhotoAndVideoClearVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  isPhoto ? items.count:videoItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAndVideoClearCellID, for: indexPath) as! PhotoAndVideoClearCell
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
            model.isSelect = !model.isSelect
            collectionView.reloadItems(at: [indexPath])
        }else{
            let model = self.videoItems[indexPath.row]
            model.isSelect = !model.isSelect
            collectionView.reloadItems(at: [indexPath])
        }
        
    }
}
