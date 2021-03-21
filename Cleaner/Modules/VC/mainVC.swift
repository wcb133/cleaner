//
//  ViewController.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit
import QMUIKit

class mainVC: BaseVC {
    
//    let circularProgressView =  CircularProgressView(frame: CGRect(x: 0, y: 150, width: 200, height: 200))
    
    let pview = CBDataOperationPieView()
    
    lazy var startCheckBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("一键检测", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.height.equalTo(48)
            m.left.equalTo(30)
            m.right.equalTo(-30)
            m.top.equalTo(self.pview.snp.bottom).offset(35)
        }
        return btn
    }()
    
    override func preferredNavigationBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pview.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(self.pview)
        self.pview.snp.makeConstraints { (m) in
             m.centerX.equalToSuperview()
            m.top.equalTo(100 + cIndicatorHeight)
             m.width.height.equalTo(200)
         }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let usedSpace = MemoryManager.getUsedSpace()
            let totalSpace = MemoryManager.getTotalSpace()
            self.pview.memoryUseLab.text = String(format: "%0.2f/%0.2fGB", usedSpace,totalSpace)
            let percent = usedSpace / totalSpace
            self.pview.setupData(percent: CGFloat(percent))
        }
        
        self.startCheckBtn.backgroundColor = HEX("2373F5")
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
//        VideoManager.shared.loadVideo { (idx, total) in
//
//        } completionHandler: { (isSuccess, error) in
//            if isSuccess{
//                self.setupVideoUI()
//            }
//        }
        
//        MemoryManager.getTotalSpace()
        
        
        
//        circularProgressView.progress = 10
//        self.view.addSubview(circularProgressView)
//        circularProgressView.backgroundColor = .green;
//        test()
        
//        self.navigationController?.pushViewController(ContactVC(), animated: true)
        
//        self.navigationController?.pushViewController(CalendarMainVC(), animated: true)
        
//        self.navigationController?.pushViewController(PhotoAndVideoClearVC(), animated: true)
        
        
        
        
    }

    func setupUI() {
        for (row,photos) in PhotoManager.shared.similarArray.enumerated() {
            for (column,photo) in photos.enumerated() {
               let img = UIImageView()
                view.addSubview(img)
                img.frame = CGRect(x: 110 * column + 10, y: 110 * row + 100, width: 100, height: 100)
                img.image = photo.exactImage
                img.clipsToBounds = true
            }
        }
        
    }
    
    func setupVideoUI() {
        for (row,photos) in VideoManager.shared.sameVideoArray.enumerated() {
            for (column,photo) in photos.enumerated() {
               let img = UIImageView()
                view.addSubview(img)
                img.frame = CGRect(x: 110 * column + 10, y: 110 * row + 100, width: 100, height: 100)
                img.image = photo.exactImage
                img.clipsToBounds = true
            }
        }
    }
    
//    func setupFuzzyUI() {
//        for (row,photo) in PhotoManager.shared.fuzzyPhotoArray.enumerated() {
//            let img = UIImageView()
//            view.addSubview(img)
//            img.frame = CGRect(x: 110 * row + 10, y: 110, width: 100, height: 100)
//            img.image = photo.exactImage
//            img.clipsToBounds = true
//        }
//    }
    
    

}

