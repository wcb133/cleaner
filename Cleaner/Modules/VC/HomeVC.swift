//
//  ViewController.swift
//  Cleaner
//
//  Created by fst on 2021/3/12.
//

import UIKit
import QMUIKit

class HomeVC: AppBaseVC {
    
    @IBOutlet weak var photoItem: UIView!
    
    @IBOutlet weak var contactItem: UIView!
    
    @IBOutlet weak var calendarItem: UIView!
    
    @IBOutlet weak var videoItem: UIView!
    
    @IBOutlet weak var aboutBtnTopInsetCons: NSLayoutConstraint!
    
    let pview = HomeCircleView()
    
    lazy var clearAllBtn: QMUIButton = {
        let btn = QMUIButton()
        btn.setTitle("一键清理", for: .normal)
        btn.backgroundColor = HEX("28B3FF")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(clearAllBtnAction(btn:)), for: .touchUpInside)
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
    
  
    @IBAction func aboutBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(AboutUsInfoVC(), animated: true)
    }
    
    @objc func clearAllBtnAction(btn:QMUIButton) {
        
        if DateTool.shared.isExpired() {
            let vc = PurchaseServiceVC()
            vc.successBlock = {
                //继续之前的操作
                let vc = AllAnalyseVC()
                vc.refreshMemeryBlock = {
                    self.refreshPieViewData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            let nav = AppBaseNav(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: nil)
            return
        }
        
        let vc = AllAnalyseVC()
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
        self.aboutBtnTopInsetCons.constant = iPhoneX ? 48 : 22
//        self.view.backgroundColor = HEX("588DFC")
        
        //杂代码
        let vc = MaintenanceVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ImageAndVideoAnalyseTool.shared.isStopScan = true
        ImageAndVideoAnalyseTool.shared.resetData()
    }
    
    func setupPview() {
        self.pview.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(self.pview)
        self.pview.snp.makeConstraints { (m) in
             m.centerX.equalToSuperview()
             m.bottom.equalTo(self.clearAllBtn.snp.top).offset(-35)
             m.width.height.equalTo(200)
         }
    }
    
    func refreshPieViewData()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let usedSpace = MemoryAnalyseTool.getUsedSpace()
            let totalSpace = MemoryAnalyseTool.getTotalSpace()
            self.pview.memoryUseLab.text = String(format: "%0.2f/%0.2fGB", usedSpace,totalSpace)
            let percent = usedSpace / totalSpace
            self.pview.setupData(percent: CGFloat(percent))
            if percent > 0.5 {
                self.clearAllBtn.backgroundColor = HEX("F15D64")
            }else {
                self.clearAllBtn.backgroundColor = HEX("28B3FF")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    @IBAction func menuBtanAction(_ sender: UIButton) {
        self.turnToBottomMenuItemAction(idx: sender.tag)
    }
    
    func turnToBottomMenuItemAction(idx:Int) {
        switch idx {
        case 0:
            let vc = ImageAndVideoAnalyseVC()
            vc.refreshMemeryBlock = {
                self.refreshPieViewData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = AddressBookManagerVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = CalendarManagerVC()
            vc.setup()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = ImageAndVideoAnalyseVC()
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

