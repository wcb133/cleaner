//
//  PhotoAndVideoClearVC.swift
//  Cleaner
//
//  Created by fst on 2021/3/21.
//

import UIKit
import QMUIKit

class PhotoAndVideoClearVC: BaseVC {
    
    var items:[String] = []
    
    lazy var deleteBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("删除选中", for: .normal)
        btn.backgroundColor = HEX("2373F5")
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
        colltionView.backgroundColor = .white
        colltionView.showsVerticalScrollIndicator = false
        colltionView.showsHorizontalScrollIndicator = false
        
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
        self.colltionView.backgroundColor = .white
        titleView?.title = "相似图片"
 
    }
}


extension PhotoAndVideoClearVC:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoAndVideoClearCellID, for: indexPath) as! PhotoAndVideoClearCell
//        cell.item = items[indexPath.row]
        cell.contentView.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = self.items[indexPath.row]
//        let vc = BKShopDetailVC()
//        vc.shopID = model.id
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
