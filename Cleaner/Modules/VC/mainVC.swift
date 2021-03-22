//
//  ViewController.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit
import QMUIKit

class mainVC: BaseVC {
    
    @IBOutlet weak var photoItem: UIView!
    
    @IBOutlet weak var contactItem: UIView!
    
    @IBOutlet weak var calendarItem: UIView!
    
    @IBOutlet weak var videoItem: UIView!
    
    
    let pview = CBDataOperationPieView()
    
    lazy var startCheckBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("推荐优化", for: .normal)
        btn.backgroundColor = HEX("3EB769")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.layer.cornerRadius = 24
        btn.layer.masksToBounds = true
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.centerY.equalToSuperview().offset(0)
            m.height.equalTo(48)
            m.left.equalTo(50)
            m.right.equalTo(-50)
        }
        return btn
    }()
    
    override func preferredNavigationBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPview()
        let views:[UIView] = [photoItem,contactItem,calendarItem,videoItem]
        for itemView in views {
            itemView.layer.cornerRadius = 8
            itemView.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
            itemView.layer.shadowOffset = CGSize(width: 0, height: 0)
            itemView.layer.shadowRadius = 3
            itemView.layer.shadowOpacity = 0.2
        }

    }
    
    func setupPview() {
        self.pview.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(self.pview)
        self.pview.snp.makeConstraints { (m) in
             m.centerX.equalToSuperview()
             m.bottom.equalTo(self.startCheckBtn.snp.top).offset(-35)
             m.width.height.equalTo(200)
         }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let usedSpace = MemoryManager.getUsedSpace()
            let totalSpace = MemoryManager.getTotalSpace()
            self.pview.memoryUseLab.text = String(format: "%0.2f/%0.2fGB", usedSpace,totalSpace)
            let percent = usedSpace / totalSpace
            self.pview.setupData(percent: CGFloat(percent))
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    @IBAction func menuBtanAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.navigationController?.pushViewController(PhotoAndVideoScanVC(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(ContactVC(), animated: true)
        case 2:
            self.navigationController?.pushViewController(CalendarMainVC(), animated: true)
        case 3:
            let vc = PhotoAndVideoScanVC()
            vc.isScanPhoto = false
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

