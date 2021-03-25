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
        btn.setTitle("一键清理", for: .normal)
        btn.backgroundColor = HEX("28B3FF")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(startCheckBtnAction(btn:)), for: .touchUpInside)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.centerY.equalToSuperview().offset(0)
            m.height.equalTo(48)
            m.width.equalTo(170)
        }
        return btn
    }()
    
    @objc func startCheckBtnAction(btn:QMUIButton) {
        
        if DateManager.shared.isExpired() {
            let vc = SubscribeVC()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
            return
        }
        
        let vc = AllScanVC()
        vc.refreshMemeryBlock = {
            self.refreshPieViewData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func preferredNavigationBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPview()
        refreshPieViewData()
    }
    
    func setupPview() {
        self.pview.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(self.pview)
        self.pview.snp.makeConstraints { (m) in
             m.centerX.equalToSuperview()
             m.bottom.equalTo(self.startCheckBtn.snp.top).offset(-35)
             m.width.height.equalTo(200)
         }

    }
    
    func refreshPieViewData()  {
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
        
        if DateManager.shared.isExpired() {
            let vc = SubscribeVC()
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true, completion: nil)
            return
        }
        
        switch sender.tag {
        case 0:
            let vc = PhotoAndVideoScanVC()
            vc.refreshMemeryBlock = {
                self.refreshPieViewData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = ContactVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = CalendarMainVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = PhotoAndVideoScanVC()
            vc.isScanPhoto = false
            vc.refreshMemeryBlock = {
                self.refreshPieViewData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

